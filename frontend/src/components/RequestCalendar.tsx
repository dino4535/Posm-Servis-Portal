import { useRef } from 'react';
import FullCalendar from '@fullcalendar/react';
import dayGridPlugin from '@fullcalendar/daygrid';
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
}

interface RequestCalendarProps {
  requests: Request[];
  onEventClick?: (request: Request) => void;
}

const RequestCalendar: React.FC<RequestCalendarProps> = ({ requests, onEventClick }) => {
  const calendarRef = useRef<FullCalendar>(null);

  const events = requests.map((request) => {
    const date = request.planlanan_tarih || request.istenen_tarih;
    let className = 'status-beklemede';
    
    if (request.durum === 'Tamamlandı') {
      className = 'status-tamamlandi';
    } else if (request.planlanan_tarih) {
      className = 'status-planlandi';
    }

    const title = request.bayi_adi 
      ? `${request.bayi_adi} - ${request.yapilacak_is}`
      : request.request_no;

    return {
      id: request.id.toString(),
      title: title.length > 30 ? title.substring(0, 27) + '...' : title,
      start: date,
      allDay: true,
      className: className,
      extendedProps: {
        request: request,
      },
    };
  });

  const handleEventClick = (info: any) => {
    if (onEventClick && info.event.extendedProps.request) {
      onEventClick(info.event.extendedProps.request);
    }
  };

  return (
    <div className="calendar-container">
      <FullCalendar
        ref={calendarRef}
        plugins={[dayGridPlugin]}
        initialView="dayGridMonth"
        locale="tr"
        events={events}
        eventClick={handleEventClick}
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
        dayMaxEvents={3}
        moreLinkText="+ daha fazla"
        eventDisplay="block"
      />
    </div>
  );
};

export default RequestCalendar;
