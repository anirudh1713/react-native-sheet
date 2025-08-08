import { StyleSheet } from 'react-native';
import RnBsView from './RnBsViewNativeComponent';
import type { NativeProps } from './RnBsViewNativeComponent';

export interface SheetProps extends NativeProps {
  largestUndimmedDetent?: 'medium' | 'large';
  detents?: Array<'medium' | 'large'>;
}

export function Sheet(props: SheetProps) {
  return (
    <RnBsView {...props} style={styles.sheetView}>
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
