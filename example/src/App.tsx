import { useState } from 'react';
import { View, StyleSheet, Text, Pressable, Modal } from 'react-native';
import { NavigationContainer } from '@react-navigation/native';
import { createNativeStackNavigator } from '@react-navigation/native-stack';
import { Sheet } from 'rn-bs';

const Stack = createNativeStackNavigator();

function HomeScreen() {
  return (
    <View style={{ flex: 1, alignItems: 'center', justifyContent: 'center' }}>
      <Text>Home Screen</Text>
    </View>
  );
}

function AwayScreen() {
  return (
    <View style={{ flex: 1, alignItems: 'center', justifyContent: 'center' }}>
      <Text>Away Screen</Text>
    </View>
  );
}

function SheetView({ onPress }: { onPress: () => void }) {
  // return (
  //   <NavigationContainer>
  //     <Stack.Navigator>
  //       <Stack.Screen name="Home" component={HomeScreen} />
  //       <Stack.Screen name="Away" component={AwayScreen} />
  //     </Stack.Navigator>
  //   </NavigationContainer>
  // );

  return (
    <View
      style={{
        flex: 1,
        left: 0,
        top: 0,
        backgroundColor: 'red',
        justifyContent: 'center',
        alignItems: 'center',
      }}
    >
      <View style={{ flex: 1, alignItems: 'center', justifyContent: 'center' }}>
        <Pressable style={{ flex: 1 }} onPress={onPress}>
          <View
            style={{ flex: 1, alignItems: 'center', justifyContent: 'center' }}
          >
            <Text style={{ color: 'black' }}>Hello</Text>
          </View>
        </Pressable>
      </View>
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
      <Sheet
        open={show}
        detents={['medium', 'large']}
        largestUndimmedDetent="medium"
        onOpenChange={setShow}
      >
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
