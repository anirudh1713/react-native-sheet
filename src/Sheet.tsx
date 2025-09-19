import { StyleSheet } from 'react-native';
import RnBsView from './RnBsViewNativeComponent';
import type { NativeProps } from './RnBsViewNativeComponent';

type Detent = 'medium' | 'large';

export interface SheetProps extends Omit<NativeProps, 'onOpenChange'> {
  largestUndimmedDetent?: Detent;
  detents?: Array<Detent>;
  onOpenChange?: (_open: boolean) => void | Promise<void>;
}

export function Sheet(props: SheetProps) {
  const onOpenChange: NonNullable<NativeProps['onOpenChange']> = (_event) => {
    props.onOpenChange?.(_event.nativeEvent.open);
  };

  return (
    <RnBsView
      {...props}
      style={[styles.sheetView, { height: props.open ? undefined : 0 }]}
      onOpenChange={onOpenChange}
    >
      {props.children}
    </RnBsView>
  );
}

const styles = StyleSheet.create({
  sheetView: {
    position: 'absolute',
    bottom: 0,
    right: 0,
  },
});
