import codegenNativeComponent from 'react-native/Libraries/Utilities/codegenNativeComponent';
import type { ViewProps } from 'react-native';
import type {
  BubblingEventHandler,
  Float,
} from 'react-native/Libraries/Types/CodegenTypes';

type OnOpenChangeEventData = {
  open: boolean;
};

export type Detent = 'medium' | 'large' | 'small';

export interface NativeProps extends ViewProps {
  open: boolean;

  // @TODO: look into codegen / other libs to figure this out
  // can't seem to get Array<Detent> to work
  // not even WithDefault<Array<Detetnt>, null>
  // ^ not sure if this is valid
  detents?: Array<string>;
  largestUndimmedDetent?: string;

  cornerRadius?: Float;

  expandOnScroll?: boolean;
  grabberVisible?: boolean;

  // @TODO: direct or bubbling event handler?
  onOpenChange?: BubblingEventHandler<OnOpenChangeEventData> | null;
}

export default codegenNativeComponent<NativeProps>('RnBsView', {
  interfaceOnly: true,
});
