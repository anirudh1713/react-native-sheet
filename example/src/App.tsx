import { useState } from 'react';
import { View, StyleSheet, Text, Pressable } from 'react-native';
import { Sheet } from 'rn-bs';

function SheetView({ onPress }: { onPress: () => void }) {
  return (
    <View
      style={{
        flex: 1,
        backgroundColor: 'red',
        justifyContent: 'center',
        alignItems: 'center',
      }}
    >
      <Text style={{ color: 'black' }}>Hello</Text>
      <Text style={{ color: 'black' }}>Hello</Text>
    </View>
  );
}

export default function App() {
  const [show, setShow] = useState(false);

  const onPress = () => {
    console.log('Button Pressed');
    setShow((_show) => !_show);
  };

  return (
    <View style={styles.container}>
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
      <Sheet
        open={show}
        onOpenChange={setShow}
        detents={['medium', 'large']}
        largestUndimmedDetent="medium"
        cornerRadius={20}
        expandOnScroll
        grabberVisible
      >
        <SheetView onPress={onPress} />
      </Sheet>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    alignItems: 'center',
    flex: 1,
    justifyContent: 'center',
  },
  box: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
    backgroundColor: 'lightblue',
  },
});
