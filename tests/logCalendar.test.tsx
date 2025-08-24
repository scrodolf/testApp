import React from 'react';
import renderer, { act } from 'react-test-renderer';
import LogCalendar from '../src/components/LogCalendar';

const propsStore: any[] = [];

jest.mock('react-native-calendars', () => ({
  Calendar: (props: any) => {
    propsStore.push(props);
    return null;
  },
}));

beforeEach(() => {
  propsStore.length = 0;
});

test('calendar uses Monday start', () => {
  act(() => {
    renderer.create(<LogCalendar selectedDate="2025-01-06" onSelect={() => {}} />);
  });
  expect(propsStore[0].firstDay).toBe(1);
});

test('selecting date fires callback', () => {
  const onSelect = jest.fn();
  act(() => {
    renderer.create(<LogCalendar selectedDate="2025-01-05" onSelect={onSelect} />);
  });
  propsStore[0].onDayPress({ dateString: '2025-01-06' });
  expect(onSelect).toHaveBeenCalledWith('2025-01-06');
});
