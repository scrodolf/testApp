import React, {useEffect, useState} from 'react';
import {View, Text, Button, FlatList} from 'react-native';
import {v4 as uuid} from 'uuid';
import {addLog, getLogs, Log} from '../services/repositories/logRepository';

const LogsScreen = () => {
  const [logs, setLogs] = useState<Log[]>([]);

  const load = async () => {
    const data = await getLogs();
    setLogs(data);
  };

  useEffect(() => {
    load();
  }, []);

  const addSample = async () => {
    await addLog({id: uuid(), meal: 'Sample Meal', date: new Date().toISOString()});
    load();
  };

  return (
    <View style={{flex: 1}}>
      <Button title="Add Log" onPress={addSample} />
      <FlatList
        data={logs}
        keyExtractor={item => item.id}
        renderItem={({item}) => <Text>{`${item.date} - ${item.meal}`}</Text>}
      />
    </View>
  );
};

export default LogsScreen;
