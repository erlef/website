// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import css from "../css/app.css"

import "phoenix_html"

// Import local files
//

import { Calendar } from '@fullcalendar/core';
import interactionPlugin from '@fullcalendar/interaction';
import dayGridPlugin from '@fullcalendar/daygrid';
import listPlugin from '@fullcalendar/list';
import bootstrapPlugin from '@fullcalendar/bootstrap';
import 'bootstrap';

document.addEventListener('DOMContentLoaded', function() {
    var calendarEl = document.getElementById('calendar');

    if (calendarEl != null) { 
        var defaultView = calendarEl.getAttribute("data-calendar-type") || "dayGridMonth";

        var header;
        if (calendarEl.getAttribute("data-calendar-header") === "true") {
            header = {
                left: 'prevYear,prev,next,nextYear',
                center: 'title',
                right: 'dayGridMonth,dayGridWeek,dayGridDay,listMonth'
            };
        } else { 
            header = '';
        }

        var calendar = new Calendar(calendarEl, {
            plugins: [interactionPlugin, dayGridPlugin, listPlugin, bootstrapPlugin],
            header: header, 
            navLinks: true,
            themeSystem: 'bootstrap',
            defaultView: defaultView,
            timezone: "local",
            eventLimit: true,
            allDaySlot: true,
            displayEventTime: true,
            displayEventEnd: true,
            firstDay: 1,
            weekNumbers: false,
            selectable: false,
            weekNumberCalculation: "ISO",
            eventLimit: true,
            eventLimitClick: 'week', //popover
            slotLabelFormat: 'HH:mm',
            weekends: true,
            nowIndicator: true,
            dayPopoverFormat: 'dddd DD/MM',
            events: window.calendar_events,
            eventRender: function (info) {
                $(info.el).popover({
                    title: info.event.title,
                    content: info.event.extendedProps.description,
                    trigger: 'hover',
                    placement: 'top',
                    container: 'body'
                });
            }
        });

        calendar.render();
    }
});

