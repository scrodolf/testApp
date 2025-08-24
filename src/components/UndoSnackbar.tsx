import React, { useEffect } from 'react';
import { Animated, StyleSheet, Text, TouchableOpacity, View } from 'react-native';

interface Props {
  visible: boolean;
  message: string;
  onUndo: () => void;
  onDismiss: () => void;
  duration?: number;
}

const UndoSnackbar: React.FC<Props> = ({ visible, message, onUndo, onDismiss, duration = 5000 }) => {
  const translateY = React.useRef(new Animated.Value(100)).current;

  useEffect(() => {
    if (visible) {
      Animated.timing(translateY, {
        toValue: 0,
        duration: 200,
        useNativeDriver: true,
      }).start();
      const timer = setTimeout(onDismiss, duration);
      return () => clearTimeout(timer);
    } else {
      Animated.timing(translateY, {
        toValue: 100,
        duration: 200,
        useNativeDriver: true,
      }).start();
    }
  }, [visible, translateY, onDismiss, duration]);

  if (!visible) return null;

  return (
    <Animated.View style={[styles.container, { transform: [{ translateY }] }]} accessible accessibilityLiveRegion="polite">
      <Text style={styles.message}>{message}</Text>
      <TouchableOpacity accessibilityRole="button" onPress={onUndo} style={styles.button}>
        <Text style={styles.buttonText}>UNDO</Text>
      </TouchableOpacity>
    </Animated.View>
  );
};

const styles = StyleSheet.create({
  container: {
    position: 'absolute',
    bottom: 16,
    left: 16,
    right: 16,
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: '#323232',
    borderRadius: 4,
    paddingHorizontal: 16,
    paddingVertical: 12,
  },
  message: {
    color: '#fff',
    flex: 1,
  },
  button: {
    paddingHorizontal: 16,
    paddingVertical: 8,
  },
  buttonText: {
    color: '#BB86FC',
    fontWeight: 'bold',
  },
});

export default UndoSnackbar;
