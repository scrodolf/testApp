import React, { useEffect, useState } from 'react';
import { View, Text, StyleSheet } from 'react-native';
import { useServices } from '../services/ServiceContext';

export default function LogsScreen() {
  const { conversionService } = useServices();
  const [example, setExample] = useState<number>(0);

  useEffect(() => {
    conversionService.ozToG(1).then(setExample);
  }, [conversionService]);

  return (
    <View style={styles.container}>
      <Text>Logs screen placeholder</Text>
      <Text>{`1 oz = ${conversionService.display(example)} g`}</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
  },
});
