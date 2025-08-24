import create from 'zustand';
import AsyncStorage from '@react-native-async-storage/async-storage';

interface OnboardingState {
  completed: boolean;
  complete: () => Promise<void>;
  hydrate: () => Promise<void>;
  reset: () => Promise<void>;
}

const useOnboardingStore = create<OnboardingState>((set, get) => ({
  completed: false,
  async complete() {
    await AsyncStorage.setItem('onboarded', 'true');
    set({completed: true});
  },
  async hydrate() {
    const flag = await AsyncStorage.getItem('onboarded');
    set({completed: flag === 'true'});
  },
  async reset() {
    await AsyncStorage.removeItem('onboarded');
    set({completed: false});
  },
}));

export default useOnboardingStore;
