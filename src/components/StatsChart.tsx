import React from 'react';
import { Dimensions, View } from 'react-native';
import { BarChart, LineChart } from 'react-native-chart-kit';
import { Text } from 'react-native-svg';

interface Props {
  data: number[];
  labels: string[];
  cap: number;
  type: 'bar' | 'line';
  color: string;
}

export default function StatsChart({ data, labels, cap, type, color }: Props) {
  const width = Dimensions.get('window').width - 32;
  const height = 220;
  const chartData = { labels, datasets: [{ data, color: () => color }] };
  const chartConfig = {
    color: () => color,
    backgroundGradientFrom: '#fff',
    backgroundGradientTo: '#fff',
    decimalPlaces: 2,
    propsForBackgroundLines: { strokeDasharray: '' },
  };
  const renderDecorator = () => (
    data.map((value, index) => (
      <Text
        key={index}
        x={(index + 0.5) * (width / labels.length)}
        y={height - (value / Math.max(cap, ...data)) * height - 4}
        fill={color}
        fontSize="10"
        textAnchor="middle"
      >
        {value.toFixed(2)}
      </Text>
    ))
  );
  const capLine = (
    <View
      style={{
        position: 'absolute',
        left: 0,
        right: 0,
        top: height - (cap / Math.max(cap, ...data)) * height,
        borderTopWidth: 1,
        borderTopColor: 'red',
      }}
    />
  );
  return (
    <View style={{ padding: 16 }}>
      {type === 'bar' ? (
        <BarChart
          width={width}
          height={height}
          data={chartData}
          chartConfig={chartConfig}
          withInnerLines
          {...({ decorator: renderDecorator } as any)}
          fromZero
        />
      ) : (
        <LineChart
          width={width}
          height={height}
          data={chartData}
          chartConfig={chartConfig}
          withDots
          bezier
          fromZero
          {...({ decorator: renderDecorator } as any)}
        />
      )}
      {capLine}
    </View>
  );
}
