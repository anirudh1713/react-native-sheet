import { StyleSheet } from 'react-native';
import RnBsView from './RnBsViewNativeComponent';
import type { NativeProps } from './RnBsViewNativeComponent';

export interface SheetProps extends NativeProps {}

export function Sheet(props: SheetProps) {
  return (
    <RnBsView {...props} style={styles.sheetView} open={props.open}>
      {props.children}
    </RnBsView>
  );
}

const styles = StyleSheet.create({
  sheetView: {
    flex: 1,
    width: '100%',
    height: '100%',
    position: 'absolute',
  },
});
