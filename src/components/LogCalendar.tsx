import React from 'react';
import { Calendar } from 'react-native-calendars';

interface Props {
  selectedDate: string; // YYYY-MM-DD
  markedDates?: Record<string, any>;
  onSelect(date: string): void;
}

const LogCalendar: React.FC<Props> = ({ selectedDate, markedDates = {}, onSelect }) => {
  return (
    <Calendar
      firstDay={1}
      markedDates={{
        ...markedDates,
        [selectedDate]: {
          selected: true,
          selectedColor: '#6200ee',
          ...(markedDates[selectedDate] || {}),
        },
      }}
      onDayPress={(day: any) => onSelect(day.dateString)}
      accessibilityRole="adjustable"
    />
  );
};

export default LogCalendar;
