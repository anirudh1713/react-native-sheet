import codegenNativeComponent from 'react-native/Libraries/Utilities/codegenNativeComponent';
import type { ViewProps } from 'react-native';

export type Detent = 'medium' | 'large' | 'small';

export interface NativeProps extends ViewProps {
  open: boolean;
  // @TODO: look into codegen / other libs to figure this out
  // can't seem to get Array<Detent> to work
  // not even WithDefault<Array<Detetnt>, null>
  // ^ not sure if this is valid
  detents?: Array<string>;
  largestUndimmedDetent?: string;
  expandOnScroll?: boolean;
}

export default codegenNativeComponent<NativeProps>('RnBsView');
