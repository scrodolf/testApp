import { Appearance } from 'react-native';

export const colors = {
  light: { background: '#ffffff', text: '#000000' },
  dark: { background: '#000000', text: '#ffffff' },
};

export function getTheme() {
  const scheme = Appearance.getColorScheme();
  return scheme === 'dark' ? colors.dark : colors.light;
}
