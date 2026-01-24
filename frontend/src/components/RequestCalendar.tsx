import { useRef, useEffect } from 'react';
import FullCalendar from '@fullcalendar/react';
import dayGridPlugin from '@fullcalendar/daygrid';
import interactionPlugin from '@fullcalendar/interaction';
import api from '../services/api';
import '../styles/RequestCalendar.css';

interface Request {
  id: number;
  request_no: string;
  dealer_id: number;
  bayi_adi?: string;
  bayi_kodu?: string;
  yapilacak_is: string;
  istenen_tarih: string;
  planlanan_tarih?: string;
  planlanan_sira?: number;
  durum: string;
  user_name?: string;
  posm_name?: string;
}

interface RequestCalendarProps {
  requests: Request[];
  onEventClick?: (request: Request) => void;
  onUpdate?: () => void;
  onError?: (msg: string) => void;
}

const RequestCalendar: React.FC<RequestCalendarProps> = ({ requests, onEventClick, onUpdate, onError }) => {
  const calendarRef = useRef<FullCalendar>(null);
  const containerRef = useRef<HTMLDivElement>(null);

  const esc = (s: string | undefined) =>
    (s ?? '')
      .toString()
      .replace(/&/g, '&amp;')
      .replace(/</g, '&lt;')
      .replace(/>/g, '&gt;')
      .replace(/"/g, '&quot;');

  const sorted = [...requests].sort((a, b) => {
    const dA = (a.planlanan_tarih || a.istenen_tarih || '').toString().slice(0, 10);
    const dB = (b.planlanan_tarih || b.istenen_tarih || '').toString().slice(0, 10);
    if (dA !== dB) return dA.localeCompare(dB);
    return (a.planlanan_sira ?? 9999) - (b.planlanan_sira ?? 9999) || a.id - b.id;
  });
  const byDate = new Map<string, Request[]>();
  for (const r of sorted) {
    const d = (r.planlanan_tarih || r.istenen_tarih || '').toString().slice(0, 10);
    if (!byDate.has(d)) byDate.set(d, []);
    byDate.get(d)!.push(r);
  }
  const events = sorted.map((request) => {
    const date = request.planlanan_tarih || request.istenen_tarih;
    const d = (date || '').toString().slice(0, 10);
    const group = byDate.get(d) || [];
    const sameDayIndex = group.indexOf(request);
    const sameDayTotal = group.length;
    let className = 'status-beklemede';
    if (request.durum === 'Tamamlandı') {
      className = 'status-tamamlandi';
    } else if (request.planlanan_tarih) {
      className = 'status-planlandi';
    }
    return {
      id: request.id.toString(),
      title: request.bayi_adi ? `${request.bayi_adi} - ${request.yapilacak_is}` : request.request_no,
      start: date,
      allDay: true,
      className,
      extendedProps: { request, sameDayIndex, sameDayTotal, dateStr: d },
      order: request.planlanan_sira ?? 9999,
    };
  });

  const handleEventClick = (info: any) => {
    if (onEventClick && info.event.extendedProps.request) {
      onEventClick(info.event.extendedProps.request);
    }
  };

  const handleEventDrop = async (info: any) => {
    const id = info.event.id;
    const start = info.event.start;
    if (!id || !start) {
      info.revert();
      onError?.('Tarih alınamadı');
      return;
    }
    const y = start.getFullYear();
    const m = start.getMonth() + 1;
    const d = start.getDate();
    const planlanan_tarih = `${y}-${String(m).padStart(2, '0')}-${String(d).padStart(2, '0')}`;
    const req = info.event.extendedProps?.request as Request | undefined;
    const rawOld = (req?.planlanan_tarih || req?.istenen_tarih || '').toString();
    const oldDate = rawOld.includes('T') ? rawOld.split('T')[0] : rawOld.slice(0, 10);

    if (oldDate === planlanan_tarih) {
      const cell = document.querySelector(`.fc-daygrid-day[data-date="${planlanan_tarih}"]`);
      if (!cell) {
        info.revert();
        onUpdate?.();
        onError?.('Sıra alınamadı');
        return;
      }
      const ids = Array.from(cell.querySelectorAll('[data-request-id]'))
        .map((el) => el.getAttribute('data-request-id'))
        .filter(Boolean)
        .map(Number);
      if (ids.length === 0) {
        info.revert();
        onUpdate?.();
        onError?.('Sıra alınamadı');
        return;
      }
      try {
        await api.put('/requests/reorder', { date: planlanan_tarih, request_ids: ids });
        onUpdate?.();
      } catch (e: any) {
        info.revert();
        onUpdate?.();
        onError?.(e.response?.data?.error || 'Sıra güncellenemedi');
      }
      return;
    }
    try {
      await api.put(`/requests/${id}`, { planlanan_tarih });
      onUpdate?.();
    } catch (e: any) {
      info.revert();
      onError?.(e.response?.data?.error || 'Tarih güncellenemedi');
    }
  };

  const eventContent = (arg: any) => {
    const r = arg.event.extendedProps?.request as Request;
    const sameDayIndex = arg.event.extendedProps?.sameDayIndex ?? 0;
    const sameDayTotal = arg.event.extendedProps?.sameDayTotal ?? 1;
    const dateStr = arg.event.extendedProps?.dateStr || '';
    if (!r) return null;
    const bayi = esc(r.bayi_adi) || '-';
    const is = esc(r.yapilacak_is) || '-';
    const acan = esc(r.user_name) || '-';
    const posm = esc(r.posm_name) || '-';
    let upBtn = '';
    let downBtn = '';
    if (sameDayTotal > 1 && dateStr) {
      if (sameDayIndex > 0) {
        upBtn = `<button type="button" class="ev-order-btn ev-up" data-request-id="${r.id}" data-action="up" data-date="${esc(dateStr)}" title="Yukarı taşı">▲</button>`;
      }
      if (sameDayIndex < sameDayTotal - 1) {
        downBtn = `<button type="button" class="ev-order-btn ev-down" data-request-id="${r.id}" data-action="down" data-date="${esc(dateStr)}" title="Aşağı taşı">▼</button>`;
      }
    }
    const actionsHtml = upBtn || downBtn ? `<div class="ev-actions">${upBtn}${downBtn}</div>` : '';
    return {
      html: `<div class="fc-custom-event" data-request-id="${r.id}" data-date="${esc(dateStr)}"><div class="ev-line1">${bayi} – ${is}</div><div class="ev-line2">Açan: ${acan} | POSM: ${posm}</div>${actionsHtml}</div>`,
    };
  };

  useEffect(() => {
    const el = containerRef.current;
    if (!el) return;
    const handleOrderClick = (e: MouseEvent) => {
      const btn = (e.target as HTMLElement)?.closest?.('.ev-order-btn');
      if (!btn) return;
      e.stopPropagation();
      e.preventDefault();
      const requestId = parseInt(btn.getAttribute('data-request-id') || '', 10);
      const action = btn.getAttribute('data-action');
      const date = btn.getAttribute('data-date');
      if (!requestId || !action || !date) return;
      (async () => {
        try {
          const dayRequests = requests
            .filter((r) => ((r.planlanan_tarih || r.istenen_tarih) || '').toString().slice(0, 10) === date)
            .sort((a, b) => (a.planlanan_sira ?? 9999) - (b.planlanan_sira ?? 9999) || a.id - b.id);
          const idx = dayRequests.findIndex((r) => r.id === requestId);
          if (idx < 0) return;
          const arr = [...dayRequests];
          if (action === 'up' && idx > 0) {
            [arr[idx - 1], arr[idx]] = [arr[idx], arr[idx - 1]];
          } else if (action === 'down' && idx < dayRequests.length - 1) {
            [arr[idx], arr[idx + 1]] = [arr[idx + 1], arr[idx]];
          } else return;
          await api.put('/requests/reorder', { date, request_ids: arr.map((r) => r.id) });
          onUpdate?.();
        } catch (err: any) {
          onError?.(err.response?.data?.error || 'Sıra güncellenemedi');
        }
      })();
    };
    el.addEventListener('click', handleOrderClick, true);
    return () => el.removeEventListener('click', handleOrderClick, true);
  }, [requests, onUpdate, onError]);

  return (
    <div ref={containerRef} className="calendar-container">
      <FullCalendar
        ref={calendarRef}
        plugins={[dayGridPlugin, interactionPlugin]}
        initialView="dayGridMonth"
        locale="tr"
        events={events}
        editable={true}
        eventClick={handleEventClick}
        eventDrop={handleEventDrop}
        eventContent={eventContent}
        eventOrder="order"
        headerToolbar={{
          left: 'prev,next today',
          center: 'title',
          right: 'dayGridMonth,dayGridWeek',
        }}
        buttonText={{
          today: 'Bugün',
          month: 'Ay',
          week: 'Hafta',
        }}
        height="auto"
        dayMaxEvents={true}
        eventDisplay="block"
        views={{ dayGridWeek: { contentHeight: 'auto', dayMaxEvents: false } }}
      />
    </div>
  );
};

export default RequestCalendar;
