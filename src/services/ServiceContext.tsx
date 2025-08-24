import React, { createContext, useContext, useEffect, useState } from 'react';
import type { SQLiteDatabase } from 'react-native-sqlite-storage';
import { initDatabase } from './database';
import {
  UnitRepository,
  ProductUnitOverrideRepository,
  ProductRepository,
  CategoryRepository,
  ProductCategoryValueRepository,
  IUnitRepository,
  IProductUnitOverrideRepository,
  IProductRepository,
  ICategoryRepository,
  IProductCategoryValueRepository,
} from './repositories';
import { ConversionService } from './ConversionService';

interface Services {
  db: SQLiteDatabase;
  unitRepository: IUnitRepository;
  productUnitOverrideRepository: IProductUnitOverrideRepository;
  productRepository: IProductRepository;
  categoryRepository: ICategoryRepository;
  productCategoryValueRepository: IProductCategoryValueRepository;
  conversionService: ConversionService;
}

export const ServiceContext = createContext<Services | undefined>(undefined);

export const ServicesProvider: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const [services, setServices] = useState<Services>();

  useEffect(() => {
    (async () => {
      const db = await initDatabase();
      const unitRepository = new UnitRepository(db);
      const productUnitOverrideRepository = new ProductUnitOverrideRepository(db);
      const productRepository = new ProductRepository(db);
      const categoryRepository = new CategoryRepository(db);
      const productCategoryValueRepository = new ProductCategoryValueRepository(db);
      const conversionService = new ConversionService(unitRepository, productUnitOverrideRepository);
      setServices({
        db,
        unitRepository,
        productUnitOverrideRepository,
        productRepository,
        categoryRepository,
        productCategoryValueRepository,
        conversionService,
      });
    })();
  }, []);

  if (!services) {
    return null;
  }

  return <ServiceContext.Provider value={services}>{children}</ServiceContext.Provider>;
};

export function useServices(): Services {
  const ctx = useContext(ServiceContext);
  if (!ctx) {
    throw new Error('useServices must be used within ServicesProvider');
  }
  return ctx;
}

