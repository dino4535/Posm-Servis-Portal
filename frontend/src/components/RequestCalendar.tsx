import { useRef } from 'react';
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

  const esc = (s: string | undefined) =>
    (s ?? '')
      .toString()
      .replace(/&/g, '&amp;')
      .replace(/</g, '&lt;')
      .replace(/>/g, '&gt;')
      .replace(/"/g, '&quot;');

  const events = requests.map((request) => {
    const date = request.planlanan_tarih || request.istenen_tarih;
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
      extendedProps: { request },
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
    if (!r) return null;
    const bayi = esc(r.bayi_adi) || '-';
    const is = esc(r.yapilacak_is) || '-';
    const acan = esc(r.user_name) || '-';
    const posm = esc(r.posm_name) || '-';
    return {
      html: `<div class="fc-custom-event"><div class="ev-line1">${bayi} – ${is}</div><div class="ev-line2">Açan: ${acan} | POSM: ${posm}</div></div>`,
    };
  };

  return (
    <div className="calendar-container">
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
        views={{ dayGridWeek: { contentHeight: 480 } }}
      />
    </div>
  );
};

export default RequestCalendar;
