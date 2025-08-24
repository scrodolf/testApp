import React, {useEffect, useState} from 'react';
import {View, Text} from 'react-native';
import {getLogs, Log} from '../services/repositories/logRepository';
import {getMeals, Meal} from '../services/repositories/mealRepository';
import {getProducts, Product} from '../services/repositories/productRepository';

const StatsScreen = () => {
  const [totalCalories, setTotalCalories] = useState(0);

  const compute = async () => {
    const [logs, meals, products] = await Promise.all([
      getLogs(),
      getMeals(),
      getProducts(),
    ]);
    const prodMap = new Map(products.map(p => [p.id, p]));
    const mealMap = new Map(meals.map(m => [m.id, m]));
    let total = 0;
    logs.forEach(log => {
      const meal = mealMap.get(log.meal);
      meal?.productIds.forEach(pid => {
        const prod = prodMap.get(pid);
        if (prod) total += prod.calories;
      });
    });
    setTotalCalories(total);
  };

  useEffect(() => {
    compute();
  }, []);

  return (
    <View style={{flex: 1, alignItems: 'center', justifyContent: 'center'}}>
      <Text>Total Calories: {totalCalories}</Text>
    </View>
  );
};

export default StatsScreen;
