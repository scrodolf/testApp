import React, {useEffect, useState} from 'react';
import {View, Text, Button, FlatList} from 'react-native';
import {v4 as uuid} from 'uuid';
import {addProduct, getProducts, Product} from '../services/repositories/productRepository';

const ProductsScreen = () => {
  const [products, setProducts] = useState<Product[]>([]);

  const load = async () => {
    const data = await getProducts();
    setProducts(data);
  };

  useEffect(() => {
    load();
  }, []);

  const addSample = async () => {
    await addProduct({id: uuid(), name: 'Sample Product', calories: 100});
    load();
  };

  return (
    <View style={{flex: 1}}>
      <Button title="Add Product" onPress={addSample} />
      <FlatList
        data={products}
        keyExtractor={item => item.id}
        renderItem={({item}) => <Text>{`${item.name} - ${item.calories} kcal`}</Text>}
      />
    </View>
  );
};

export default ProductsScreen;
