import { useState } from 'react';
import { View, StyleSheet, Text, Pressable, Modal } from 'react-native';
import { Sheet } from 'rn-bs';

function SheetView({ onPress }: { onPress: () => void }) {
  return (
    <View
      style={{
        flex: 1,
        left: 0,
        top: 0,
        backgroundColor: 'white',
      }}
    >
      <Pressable style={{ flex: 1 }} onPress={onPress}>
        <View>
          <Text style={{ color: 'black' }}>Hello</Text>
        </View>
        <View>
          <Text>LFG</Text>
        </View>
      </Pressable>
    </View>
  );
}

export default function App() {
  const [show, setShow] = useState(true);

  const onPress = () => {
    console.log('Button Pressed');
    setShow((_show) => !_show);
  };

  return (
    <View style={styles.container}>
      <Modal visible={false} style={{ marginTop: 180 }} transparent={true}>
        <Text>From Modal</Text>
      </Modal>
      <View style={{ marginTop: 100 }}>
        <Pressable onPress={onPress}>
          <Text style={{ color: 'black' }}>Open the thing important</Text>
        </Pressable>
      </View>
      <View style={styles.box}>
        <Pressable onPress={onPress}>
          <Text style={{ color: 'black' }}>Open the thing</Text>
        </Pressable>
      </View>
      <Sheet open={show}>
        <SheetView onPress={onPress} />
      </Sheet>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  box: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
    backgroundColor: 'lightblue',
  },
});
