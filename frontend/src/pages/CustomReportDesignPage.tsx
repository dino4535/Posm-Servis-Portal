import { useState, useEffect, useCallback } from 'react';
import {
  DndContext,
  DragOverlay,
  closestCenter,
  KeyboardSensor,
  PointerSensor,
  useSensor,
  useSensors,
  DragStartEvent,
  DragEndEvent,
  useDraggable,
  useDroppable,
} from '@dnd-kit/core';
import * as XLSX from 'xlsx';
import api from '../services/api';
import { useAuth } from '../context/AuthContext';
import { useToast } from '../context/ToastContext';
import '../styles/CustomReportDesignPage.css';

interface TableConfig {
  name: string;
  alias: string;
  columns: string[];
}

interface ColumnItem {
  id: string;
  table: string;
  column: string;
  alias: string;
  type: 'normal' | 'aggregate';
  function?: 'SUM' | 'COUNT' | 'AVG' | 'MAX' | 'MIN';
}

interface PivotConfig {
  rows: ColumnItem[];
  columns: ColumnItem[];
  values: ColumnItem[];
}

// Draggable Column Component
const DraggableColumn = ({ table, column }: { table: string; column: string }) => {
  const { attributes, listeners, setNodeRef, transform, isDragging } = useDraggable({
    id: `${table}::${column}`,
    data: {
      table,
      column,
    },
  });

  const style = transform
    ? {
        transform: `translate3d(${transform.x}px, ${transform.y}px, 0)`,
      }
    : undefined;

  return (
    <div
      ref={setNodeRef}
      style={style}
      className={`draggable-column ${isDragging ? 'dragging' : ''}`}
      {...listeners}
      {...attributes}
    >
      <span className="column-icon">📊</span>
      <span className="column-name">{column}</span>
    </div>
  );
};

// Droppable Pivot Group Component
const DroppablePivotGroup = ({
  id,
  label,
  items,
  type,
  onRemove,
  onUpdate,
}: {
  id: string;
  label: string;
  items: ColumnItem[];
  type: 'rows' | 'columns' | 'values';
  onRemove: (item: ColumnItem) => void;
  onUpdate: (item: ColumnItem, field: 'alias' | 'function', value: any) => void;
}) => {
  const { setNodeRef, isOver } = useDroppable({
    id,
  });

  return (
    <div
      ref={setNodeRef}
      id={id}
      className={`pivot-group ${isOver ? 'drag-over' : ''}`}
    >
      <label>{label}</label>
      <div className="pivot-items">
        {items.length === 0 ? (
          <div className="empty-drop-zone">Sütunları buraya sürükleyin</div>
        ) : (
          items.map((item) => (
            <div key={item.id} className="pivot-item">
              <input
                type="text"
                value={item.alias}
                onChange={(e) => onUpdate(item, 'alias', e.target.value)}
                className="pivot-item-alias"
                placeholder="Alias"
              />
              {type === 'values' && (
                <select
                  value={item.function || 'SUM'}
                  onChange={(e) => onUpdate(item, 'function', e.target.value)}
                  className="pivot-item-function"
                >
                  <option value="SUM">Toplam</option>
                  <option value="COUNT">Sayı</option>
                  <option value="AVG">Ortalama</option>
                  <option value="MAX">Maksimum</option>
                  <option value="MIN">Minimum</option>
                </select>
              )}
              <span className="pivot-item-info">
                {item.table}.{item.column}
              </span>
              <button
                className="btn-remove-small"
                onClick={() => onRemove(item)}
              >
                ✕
              </button>
            </div>
          ))
        )}
      </div>
    </div>
  );
};

// Mevcut tablolar
const availableTables: TableConfig[] = [
  { name: 'Requests', alias: 'Talepler', columns: ['id', 'request_no', 'durum', 'yapilacak_is', 'istenen_tarih', 'planlanan_tarih', 'tamamlanma_tarihi', 'priority', 'created_at', 'user_id', 'dealer_id', 'depot_id', 'territory_id'] },
  { name: 'Dealers', alias: 'Bayiler', columns: ['id', 'code', 'name', 'territory_id', 'address', 'phone', 'latitude', 'longitude'] },
  { name: 'Depots', alias: 'Depolar', columns: ['id', 'name', 'code', 'address'] },
  { name: 'Territories', alias: 'Bölgeler', columns: ['id', 'name', 'code', 'depot_id'] },
  { name: 'POSM', alias: 'POSM', columns: ['id', 'name', 'depot_id', 'hazir_adet', 'tamir_bekleyen'] },
  { name: 'Users', alias: 'Kullanıcılar', columns: ['id', 'name', 'email', 'role'] },
];

const CustomReportDesignPage = () => {
  const { isAdmin } = useAuth();
  const { showSuccess, showError, showWarning } = useToast();
  const [templates, setTemplates] = useState<any[]>([]);
  const [selectedTemplate, setSelectedTemplate] = useState<any>(null);
  const [reportName, setReportName] = useState('');
  const [description, setDescription] = useState('');
  const [pivotConfig, setPivotConfig] = useState<PivotConfig>({
    rows: [],
    columns: [],
    values: [],
  });
  const [previewData, setPreviewData] = useState<any[]>([]);
  const [loading, setLoading] = useState(false);
  const [activeId, setActiveId] = useState<string | null>(null);
  const [expandedTables, setExpandedTables] = useState<Set<string>>(new Set());
  const [filters, setFilters] = useState({
    start_date: '',
    end_date: '',
    depot_id: '',
  });
  const [depots, setDepots] = useState<any[]>([]);

  const sensors = useSensors(
    useSensor(PointerSensor),
    useSensor(KeyboardSensor)
  );

  useEffect(() => {
    fetchTemplates();
    fetchDepots();
  }, []);

  const fetchDepots = async () => {
    try {
      const response = await api.get('/depots');
      if (response.data.success) {
        setDepots(response.data.data);
      }
    } catch (error) {
      console.error('Depolar yüklenirken hata:', error);
    }
  };

  const fetchTemplates = async () => {
    try {
      const response = await api.get('/custom-reports/templates');
      if (response.data.success) {
        setTemplates(response.data.data);
      }
    } catch (error) {
      console.error('Rapor şablonları yüklenirken hata:', error);
    }
  };

  const handleDragStart = (event: DragStartEvent) => {
    setActiveId(event.active.id as string);
  };

  const handleDragEnd = (event: DragEndEvent) => {
    const { active, over } = event;
    setActiveId(null);

    if (!over || !active.id) return;

    const activeData = active.data.current;
    if (!activeData || !activeData.table || !activeData.column) return;

    const { table, column } = activeData;
    const overId = over.id as string;
    let target: 'rows' | 'columns' | 'values' | null = null;

    if (overId === 'rows-drop') {
      target = 'rows';
    } else if (overId === 'columns-drop') {
      target = 'columns';
    } else if (overId === 'values-drop') {
      target = 'values';
    }

    if (!target) return;

    if (target === 'rows') {
      const newItem: ColumnItem = {
        id: `${table}-${column}-${Date.now()}`,
        table,
        column,
        alias: column,
        type: 'normal',
      };
      setPivotConfig({
        ...pivotConfig,
        rows: [...pivotConfig.rows.filter((r) => !(r.table === table && r.column === column)), newItem],
        columns: pivotConfig.columns.filter((c) => !(c.table === table && c.column === column)),
        values: pivotConfig.values.filter((v) => !(v.table === table && v.column === column)),
      });
    } else if (target === 'columns') {
      const newItem: ColumnItem = {
        id: `${table}-${column}-${Date.now()}`,
        table,
        column,
        alias: column,
        type: 'normal',
      };
      setPivotConfig({
        ...pivotConfig,
        columns: [...pivotConfig.columns.filter((c) => !(c.table === table && c.column === column)), newItem],
        rows: pivotConfig.rows.filter((r) => !(r.table === table && r.column === column)),
        values: pivotConfig.values.filter((v) => !(v.table === table && v.column === column)),
      });
    } else if (target === 'values') {
      const newItem: ColumnItem = {
        id: `${table}-${column}-${Date.now()}`,
        table,
        column,
        alias: column,
        type: 'aggregate',
        function: 'SUM',
      };
      setPivotConfig({
        ...pivotConfig,
        values: [...pivotConfig.values.filter((v) => !(v.table === table && v.column === column)), newItem],
        rows: pivotConfig.rows.filter((r) => !(r.table === table && r.column === column)),
        columns: pivotConfig.columns.filter((c) => !(c.table === table && c.column === column)),
      });
    }
  };

  const removeFromPivot = (item: ColumnItem, type: 'rows' | 'columns' | 'values') => {
    if (type === 'rows') {
      setPivotConfig({ ...pivotConfig, rows: pivotConfig.rows.filter((r) => r.id !== item.id) });
    } else if (type === 'columns') {
      setPivotConfig({ ...pivotConfig, columns: pivotConfig.columns.filter((c) => c.id !== item.id) });
    } else if (type === 'values') {
      setPivotConfig({ ...pivotConfig, values: pivotConfig.values.filter((v) => v.id !== item.id) });
    }
  };

  const updatePivotItem = (item: ColumnItem, type: 'rows' | 'columns' | 'values', field: 'alias' | 'function', value: any) => {
    const updateItem = (items: ColumnItem[]) =>
      items.map((i) => (i.id === item.id ? { ...i, [field]: value } : i));

    if (type === 'rows') {
      setPivotConfig({ ...pivotConfig, rows: updateItem(pivotConfig.rows) });
    } else if (type === 'columns') {
      setPivotConfig({ ...pivotConfig, columns: updateItem(pivotConfig.columns) });
    } else if (type === 'values') {
      setPivotConfig({ ...pivotConfig, values: updateItem(pivotConfig.values) });
    }
  };

  const buildQueryConfig = useCallback(() => {
    const allTables = new Set<string>();
    [...pivotConfig.rows, ...pivotConfig.columns, ...pivotConfig.values].forEach((item) => {
      allTables.add(item.table);
    });

    const tables = Array.from(allTables).map((t) => {
      const tableInfo = availableTables.find((at) => at.name === t);
      return { name: t, alias: tableInfo?.alias || t };
    });

    const joins: any[] = [];
    const tableList = Array.from(allTables);
    const usedTables = new Set<string>();
    usedTables.add(tables[0]?.name || 'Requests');
    
    // JOIN'leri sırayla ekle, aynı tablo birden fazla kez kullanılıyorsa alias ekle
    if (tableList.includes('Requests') && tableList.includes('Dealers') && !usedTables.has('Dealers')) {
      joins.push({
        type: 'LEFT',
        table: 'Dealers',
        on: 'Requests.dealer_id = Dealers.id',
      });
      usedTables.add('Dealers');
    }
    if (tableList.includes('Requests') && tableList.includes('Depots') && !usedTables.has('Depots')) {
      joins.push({
        type: 'LEFT',
        table: 'Depots',
        on: 'Requests.depot_id = Depots.id',
      });
      usedTables.add('Depots');
    }
    if (tableList.includes('Requests') && tableList.includes('Territories') && !usedTables.has('Territories')) {
      joins.push({
        type: 'LEFT',
        table: 'Territories',
        on: 'Requests.territory_id = Territories.id',
      });
      usedTables.add('Territories');
    }
    if (tableList.includes('Dealers') && tableList.includes('Territories') && !usedTables.has('Territories')) {
      joins.push({
        type: 'LEFT',
        table: 'Territories',
        on: 'Dealers.territory_id = Territories.id',
      });
      usedTables.add('Territories');
    }
    if (tableList.includes('Territories') && tableList.includes('Depots') && !usedTables.has('Depots')) {
      joins.push({
        type: 'LEFT',
        table: 'Depots',
        on: 'Territories.depot_id = Depots.id',
      });
      usedTables.add('Depots');
    }
    if (tableList.includes('Requests') && tableList.includes('Users') && !usedTables.has('Users')) {
      joins.push({
        type: 'LEFT',
        table: 'Users',
        on: 'Requests.user_id = Users.id',
      });
      usedTables.add('Users');
    }
    // Kullanıcının territory'si için Requests üzerinden Territories'ye JOIN
    // (Users tablosunda territory_id yok, Requests'te var)
    if (tableList.includes('Users') && tableList.includes('Territories') && !usedTables.has('Territories')) {
      // Eğer Requests zaten varsa, Requests üzerinden Territories'ye JOIN yap
      if (tableList.includes('Requests')) {
        joins.push({
          type: 'LEFT',
          table: 'Territories',
          on: 'Requests.territory_id = Territories.id',
        });
        usedTables.add('Territories');
      }
    }

    const allColumns = [...pivotConfig.rows, ...pivotConfig.columns, ...pivotConfig.values];
    const queryColumns = allColumns.map((col) => ({
      table: col.table,
      column: col.column,
      alias: col.alias || col.column,
      type: col.type,
      function: col.function,
    }));

    return {
      tables,
      joins,
      columns: queryColumns,
      where_conditions: [],
      group_by: pivotConfig.rows.length > 0 
        ? pivotConfig.rows.map((r) => {
            const tablePrefix = r.table ? `${r.table}.` : '';
            return `${tablePrefix}${r.column}`;
          })
        : undefined,
      order_by: pivotConfig.rows.length > 0 
        ? pivotConfig.rows.map((r) => {
            const tablePrefix = r.table ? `${r.table}.` : '';
            return `${tablePrefix}${r.column} ASC`;
          })
        : (tables.length > 0 && tables[0]?.name ? [`${tables[0].name}.id ASC`] : []),
      filters: filters.start_date || filters.end_date || filters.depot_id ? {
        start_date: filters.start_date || undefined,
        end_date: filters.end_date || undefined,
        depot_id: filters.depot_id || undefined,
      } : undefined,
    };
  }, [pivotConfig, filters]);

  const buildPivotConfigForSave = useCallback(() => {
    return {
      rows: pivotConfig.rows.map((r) => r.alias || r.column),
      columns: pivotConfig.columns.map((c) => c.alias || c.column),
      values: pivotConfig.values.map((v) => v.alias || v.column),
      aggregations: Object.fromEntries(
        pivotConfig.values.map((v) => [v.alias || v.column, v.function || 'SUM'])
      ),
    };
  }, [pivotConfig]);

  const handlePreview = async () => {
    if (pivotConfig.rows.length === 0 && pivotConfig.columns.length === 0 && pivotConfig.values.length === 0) {
      showWarning('Lütfen en az bir sütun seçin');
      return;
    }

    setLoading(true);
    try {
      const queryConfig = buildQueryConfig();
      const pivotConfigData = buildPivotConfigForSave();

      // Test için geçici template oluştur
      // query_config zaten object olarak gönderilmeli, backend stringify edecek
      const tempTemplate = {
        name: 'Preview',
        config: pivotConfigData, // Backend stringify edecek
        query_config: queryConfig, // Backend stringify edecek
      };

      const createResponse = await api.post('/custom-reports/templates', tempTemplate);
      if (createResponse.data.success) {
        const templateId = createResponse.data.data.id;
        try {
          // Execute endpoint'ine filtreleri gönder
        const executeResponse = await api.post(`/custom-reports/templates/${templateId}/execute`, {
          filters: queryConfig.filters,
        });
          if (executeResponse.data.success) {
            setPreviewData(executeResponse.data.data);
          } else {
            showError('Önizleme çalıştırılamadı: ' + (executeResponse.data.error || 'Bilinmeyen hata'));
          }
        } catch (error: any) {
          console.error('Önizleme çalıştırma hatası:', error);
          console.error('Error Response:', error.response);
          const errorMessage = error.response?.data?.error || error.response?.data?.details || error.response?.data?.message || error.message || 'Önizleme oluşturulurken hata oluştu';
          showError('Hata: ' + errorMessage);
        }
        // Geçici template'i sil
        try {
          await api.delete(`/custom-reports/templates/${templateId}`);
        } catch (error) {
          console.error('Geçici template silme hatası:', error);
        }
      } else {
        showError('Template oluşturulamadı: ' + (createResponse.data.error || 'Bilinmeyen hata'));
      }
    } catch (error: any) {
      console.error('Önizleme hatası:', error);
      const errorMessage = error.response?.data?.error || error.response?.data?.message || error.message || 'Önizleme oluşturulurken hata oluştu';
      showError('Hata: ' + errorMessage);
    } finally {
      setLoading(false);
    }
  };

  const handleSave = async () => {
    if (!reportName) {
      showWarning('Lütfen rapor adı girin');
      return;
    }

    if (pivotConfig.rows.length === 0 && pivotConfig.columns.length === 0 && pivotConfig.values.length === 0) {
      showWarning('Lütfen en az bir sütun seçin');
      return;
    }

    setLoading(true);
    try {
      const queryConfig = buildQueryConfig();
      const pivotConfigData = buildPivotConfigForSave();

      const templateData = {
        name: reportName,
        description,
        config: pivotConfigData,
        query_config: queryConfig,
      };

      if (selectedTemplate) {
        await api.put(`/custom-reports/templates/${selectedTemplate.id}`, templateData);
        showSuccess('Rapor şablonu güncellendi');
      } else {
        await api.post('/custom-reports/templates', templateData);
        showSuccess('Rapor şablonu kaydedildi');
      }

      fetchTemplates();
      resetForm();
    } catch (error: any) {
      showError(error.response?.data?.error || 'Rapor kaydedilirken hata oluştu');
    } finally {
      setLoading(false);
    }
  };

  const resetForm = () => {
    setReportName('');
    setDescription('');
    setPivotConfig({ rows: [], columns: [], values: [] });
    setPreviewData([]);
    setSelectedTemplate(null);
  };

  const loadTemplate = (template: any) => {
    setSelectedTemplate(template);
    setReportName(template.name);
    setDescription(template.description || '');
    
    const config = JSON.parse(template.config);
    const queryConfig = JSON.parse(template.query_config);

    const loadedRows: ColumnItem[] = (config.rows || []).map((rowAlias: string, index: number) => {
      const col = queryConfig.columns.find((c: any) => c.alias === rowAlias);
      return {
        id: `row-${Date.now()}-${index}`,
        table: col?.table || '',
        column: col?.column || rowAlias,
        alias: rowAlias,
        type: 'normal',
      };
    });

    const loadedColumns: ColumnItem[] = (config.columns || []).map((colAlias: string, index: number) => {
      const col = queryConfig.columns.find((c: any) => c.alias === colAlias);
      return {
        id: `col-${Date.now()}-${index}`,
        table: col?.table || '',
        column: col?.column || colAlias,
        alias: colAlias,
        type: 'normal',
      };
    });

    const loadedValues: ColumnItem[] = (config.values || []).map((valAlias: string, index: number) => {
      const col = queryConfig.columns.find((c: any) => c.alias === valAlias);
      return {
        id: `val-${Date.now()}-${index}`,
        table: col?.table || '',
        column: col?.column || valAlias,
        alias: valAlias,
        type: 'aggregate',
        function: config.aggregations?.[valAlias] || 'SUM',
      };
    });

    setPivotConfig({
      rows: loadedRows,
      columns: loadedColumns,
      values: loadedValues,
    });
  };

  const toggleTable = (tableName: string) => {
    const newExpanded = new Set(expandedTables);
    if (newExpanded.has(tableName)) {
      newExpanded.delete(tableName);
    } else {
      newExpanded.add(tableName);
    }
    setExpandedTables(newExpanded);
  };

  const exportToExcel = () => {
    if (previewData.length === 0) {
      showError('Dışa aktarılacak veri bulunmamaktadır');
      return;
    }

    try {
      // Workbook oluştur
      const workbook = XLSX.utils.book_new();

      // Veriyi worksheet'e dönüştür
      const worksheet = XLSX.utils.json_to_sheet(previewData);

      // Sütun genişliklerini ayarla
      const maxWidth = 50;
      const colWidths = Object.keys(previewData[0] || {}).map((key) => {
        const maxLength = Math.max(
          key.length,
          ...previewData.map((row: any) => String(row[key] || '').length)
        );
        return { wch: Math.min(maxLength + 2, maxWidth) };
      });
      worksheet['!cols'] = colWidths;

      // Worksheet'i workbook'a ekle
      const sheetName = reportName || 'Rapor';
      XLSX.utils.book_append_sheet(workbook, worksheet, sheetName.substring(0, 31)); // Excel sheet adı max 31 karakter

      // Excel dosyasını indir
      const fileName = `${reportName || 'Rapor'}_${new Date().toISOString().split('T')[0]}.xlsx`;
      XLSX.writeFile(workbook, fileName);

      showSuccess('Excel dosyası başarıyla indirildi');
    } catch (error: any) {
      console.error('Excel export hatası:', error);
      showError('Excel dosyası oluşturulurken hata oluştu: ' + (error.message || 'Bilinmeyen hata'));
    }
  };

  if (!isAdmin) {
    return <div className="no-access">Bu sayfaya erişim yetkiniz yok.</div>;
  }

  const getActiveItem = () => {
    if (!activeId) return null;
    const [table, column] = activeId.split('::');
    return { table, column };
  };

  const activeItem = getActiveItem();

  return (
    <DndContext
      sensors={sensors}
      collisionDetection={closestCenter}
      onDragStart={handleDragStart}
      onDragEnd={handleDragEnd}
    >
      <div className="custom-report-design-page">
        <div className="page-header">
          <h2>Serbest Rapor Tasarımı</h2>
          <div className="header-actions">
            <button className="btn-secondary" onClick={resetForm}>
              Yeni Rapor
            </button>
            <button className="btn-secondary" onClick={handlePreview} disabled={loading}>
              {loading ? 'Yükleniyor...' : 'Önizleme'}
            </button>
            <button className="btn-primary" onClick={handleSave} disabled={loading}>
              {selectedTemplate ? 'Güncelle' : 'Kaydet'}
            </button>
          </div>
        </div>

        <div className="filters-section">
          <h3>Filtreler</h3>
          <div className="filters-grid">
            <div className="filter-group">
              <label>Başlangıç Tarihi</label>
              <input
                type="date"
                value={filters.start_date}
                onChange={(e) => setFilters({ ...filters, start_date: e.target.value })}
              />
            </div>
            <div className="filter-group">
              <label>Bitiş Tarihi</label>
              <input
                type="date"
                value={filters.end_date}
                onChange={(e) => setFilters({ ...filters, end_date: e.target.value })}
              />
            </div>
            <div className="filter-group">
              <label>Depo</label>
              <select
                value={filters.depot_id}
                onChange={(e) => setFilters({ ...filters, depot_id: e.target.value })}
              >
                <option value="">Tüm Depolar</option>
                {depots.map((depot) => (
                  <option key={depot.id} value={depot.id}>
                    {depot.name}
                  </option>
                ))}
              </select>
            </div>
            <div className="filter-group">
              <button
                className="btn-secondary"
                onClick={() => setFilters({ start_date: '', end_date: '', depot_id: '' })}
              >
                Filtreleri Temizle
              </button>
            </div>
          </div>
        </div>

        <div className="design-layout-top">
          <div className="left-panel">
            <div className="panel-section">
              <h3>Mevcut Şablonlar</h3>
              <div className="templates-list">
                {templates.map((template) => (
                  <div
                    key={template.id}
                    className={`template-item ${selectedTemplate?.id === template.id ? 'active' : ''}`}
                    onClick={() => loadTemplate(template)}
                  >
                    <div className="template-name">{template.name}</div>
                    <div className="template-meta">
                      {new Date(template.created_at).toLocaleDateString('tr-TR', {
                        timeZone: 'Europe/Istanbul',
                      })}
                    </div>
                  </div>
                ))}
              </div>
            </div>

            <div className="panel-section">
              <h3>Tablolar ve Sütunlar</h3>
              <div className="tables-columns-list">
                {availableTables.map((table) => (
                  <div key={table.name} className="table-group">
                    <div
                      className="table-header"
                      onClick={() => toggleTable(table.name)}
                    >
                      <span className="table-toggle">
                        {expandedTables.has(table.name) ? '▼' : '▶'}
                      </span>
                      <span className="table-name">{table.alias}</span>
                      <span className="table-code">({table.name})</span>
                    </div>
                    {expandedTables.has(table.name) && (
                      <div className="columns-list">
                        {table.columns.map((column) => (
                          <DraggableColumn
                            key={`${table.name}-${column}`}
                            table={table.name}
                            column={column}
                          />
                        ))}
                      </div>
                    )}
                  </div>
                ))}
              </div>
            </div>
          </div>

          <div className="center-panel">
            <div className="form-section">
              <div className="form-group">
                <label>Rapor Adı *</label>
                <input
                  type="text"
                  value={reportName}
                  onChange={(e) => setReportName(e.target.value)}
                  placeholder="Rapor adını girin"
                />
              </div>
              <div className="form-group">
                <label>Açıklama</label>
                <textarea
                  value={description}
                  onChange={(e) => setDescription(e.target.value)}
                  rows={2}
                  placeholder="Rapor açıklaması"
                />
              </div>
            </div>

            <div className="pivot-section">
              <h3>Pivot Table Yapılandırması</h3>
              <p className="section-hint">
                Sol panelden sütunları sürükleyip aşağıdaki alanlara bırakın
              </p>
              
              <div className="pivot-config">
                <DroppablePivotGroup
                  id="rows-drop"
                  label="Satırlar (Row)"
                  items={pivotConfig.rows}
                  type="rows"
                  onRemove={(item) => removeFromPivot(item, 'rows')}
                  onUpdate={(item, field, value) => updatePivotItem(item, 'rows', field, value)}
                />
                <DroppablePivotGroup
                  id="columns-drop"
                  label="Sütunlar (Column)"
                  items={pivotConfig.columns}
                  type="columns"
                  onRemove={(item) => removeFromPivot(item, 'columns')}
                  onUpdate={(item, field, value) => updatePivotItem(item, 'columns', field, value)}
                />
                <DroppablePivotGroup
                  id="values-drop"
                  label="Değerler (Values - Toplam)"
                  items={pivotConfig.values}
                  type="values"
                  onRemove={(item) => removeFromPivot(item, 'values')}
                  onUpdate={(item, field, value) => updatePivotItem(item, 'values', field, value)}
                />
              </div>
            </div>
          </div>
        </div>

        {(previewData.length > 0 || loading) && (
          <div className="preview-section-bottom">
            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '16px' }}>
              <h3>
                Önizleme {loading && <span className="loading-indicator">⏳</span>}
                {!loading && previewData.length > 0 && (
                  <span className="preview-count">({previewData.length} kayıt)</span>
                )}
              </h3>
              {!loading && previewData.length > 0 && (
                <button
                  onClick={exportToExcel}
                  className="export-button"
                  style={{
                    padding: '8px 16px',
                    background: '#27ae60',
                    color: 'white',
                    border: 'none',
                    borderRadius: '4px',
                    cursor: 'pointer',
                    fontSize: '14px',
                    fontWeight: '500',
                  }}
                >
                  📊 Excel'e Aktar
                </button>
              )}
            </div>
            {previewData.length === 0 && !loading ? (
              <div className="preview-empty">
                <p>Önizleme butonuna tıklayarak raporu görüntüleyin</p>
              </div>
            ) : (
              <div className="preview-table-container">
                <table className="preview-table">
                  <thead>
                    <tr>
                      {previewData.length > 0 &&
                        Object.keys(previewData[0]).map((key) => (
                          <th key={key}>{key}</th>
                        ))}
                    </tr>
                  </thead>
                  <tbody>
                    {previewData.slice(0, 100).map((row: any, idx: number) => (
                      <tr key={idx}>
                        {Object.values(row).map((val: any, i: number) => (
                          <td key={i}>{val !== null && val !== undefined ? String(val) : '-'}</td>
                        ))}
                      </tr>
                    ))}
                  </tbody>
                </table>
                {previewData.length > 100 && (
                  <div className="preview-note">
                    Toplam {previewData.length} kayıt (ilk 100 gösteriliyor)
                  </div>
                )}
              </div>
            )}
          </div>
        )}
      </div>
      <DragOverlay>
        {activeItem ? (
          <div className="drag-overlay-item">
            {activeItem.table}.{activeItem.column}
          </div>
        ) : null}
      </DragOverlay>
    </DndContext>
  );
};

export default CustomReportDesignPage;
