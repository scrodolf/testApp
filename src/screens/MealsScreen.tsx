import React, {useEffect, useState} from 'react';
import {View, Text, Button, FlatList} from 'react-native';
import {v4 as uuid} from 'uuid';
import {addMeal, getMeals, Meal} from '../services/repositories/mealRepository';
import {getProducts, Product} from '../services/repositories/productRepository';

const MealsScreen = () => {
  const [meals, setMeals] = useState<Meal[]>([]);
  const [products, setProducts] = useState<Product[]>([]);

  const load = async () => {
    setMeals(await getMeals());
    setProducts(await getProducts());
  };

  useEffect(() => {
    load();
  }, []);

  const addSample = async () => {
    const prod = products[0];
    if (!prod) {
      await load();
      return;
    }
    await addMeal({id: uuid(), name: 'Sample Meal', productIds: [prod.id]});
    load();
  };

  const renderItem = ({item}: {item: Meal}) => (
    <Text>{`${item.name} - ${item.productIds.length} products`}</Text>
  );

  return (
    <View style={{flex: 1}}>
      <Button title="Add Meal" onPress={addSample} />
      <FlatList data={meals} keyExtractor={i => i.id} renderItem={renderItem} />
    </View>
  );
};

export default MealsScreen;
