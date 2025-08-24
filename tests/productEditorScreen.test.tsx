import React from 'react';
import renderer, { act } from 'react-test-renderer';
import ProductEditorScreen from '../src/screens/ProductEditorScreen';
import { ServiceContext } from '../src/services/ServiceContext';

jest.mock('react-native', () => ({
  View: 'View',
  Text: 'Text',
  TextInput: 'TextInput',
  ScrollView: 'ScrollView',
  TouchableOpacity: 'TouchableOpacity',
  StyleSheet: { create: () => ({}) },
}));

jest.mock('@react-native-picker/picker', () => {
  const React = require('react');
  const MockPicker = (props: any) => React.createElement('Picker', props, props.children);
  MockPicker.Item = (props: any) => React.createElement('PickerItem', props);
  return { Picker: MockPicker };
});

jest.mock('react-native-sqlite-storage', () => ({}));
jest.mock('../src/services/database', () => ({ initDatabase: async () => ({ executeSql: jest.fn(), transaction: jest.fn() }) }));

(global as any).IS_REACT_ACT_ENVIRONMENT = true;

const mockServices: any = {
  productRepository: {
    create: jest.fn(),
    update: jest.fn(),
    getById: jest.fn().mockResolvedValue(null),
  },
  unitRepository: {
    getAll: jest.fn().mockResolvedValue([
      { id: 1, name: 'gram', symbol: 'g', dimension: 'MASS', factorToBase: 1, isCustom: false },
    ]),
  },
  categoryRepository: {
    getAll: jest.fn().mockResolvedValue([]),
  },
  productCategoryValueRepository: {
    getForProduct: jest.fn().mockResolvedValue([]),
    upsert: jest.fn(),
  },
  productUnitOverrideRepository: {
    getOverride: jest.fn().mockResolvedValue(null),
    upsert: jest.fn(),
  },
  conversionService: {
    toBase: jest.fn(async (v) => v),
    fromBase: jest.fn(async (v) => v),
  },
  db: {},
};

describe('ProductEditorScreen validation', () => {
  it('disables save when name is empty', async () => {
    const navigation: any = { goBack: jest.fn() };
    let component: renderer.ReactTestRenderer | null = null;
    await act(async () => {
      component = renderer.create(
        <ServiceContext.Provider value={mockServices}>
          <ProductEditorScreen navigation={navigation} route={{ params: {} } as any} />
        </ServiceContext.Provider>
      );
    });
    const saveText = component!.root.findByProps({ children: 'Save' });
    const saveButton = saveText.parent as any;
    expect(saveButton.props.accessibilityState.disabled).toBe(true);
  });
});
