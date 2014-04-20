SPNavigationController - UINavigationController With Custom Transitions
======================

This is a UINavigationController that allows for all custom slide animations, not just the usual slide from right to left. Easy to plugin to an iOS Project, and you will have access to a navigation controller structure, fully customisable navigation view. Implemented using a containment controller.

##Contents

* [Getting Started] (#Getting-Started)
* [Examples] (#examples)
* [Transitions] (#transitions)
* [Minimum Requirements] (#minimum-requirement)
* [Other] (#other)

### <a name="Getting-Started"></a> Getting Started

1. git clone https://github.com/psandeepunni/SPNavigationController.git
2. Drag and drop the "SPNavigationController" folder to your iOS project. Please remember to check copy folder contents option.
3. Add import statement for "SPNavigationUIKit" to your projectName-prefix.pch file


### <a name="examples"></a> Examples

1. To add the navigation controller to your window object

```javascript
	self.window.rootViewController = [[SPNavigationController alloc] initWithRootViewController:initViewController];
```

2. Push a view controller from another view controller 

```javascript
SPChildViewController *child = [[SPChildViewController alloc] initWithNibName:@"SPChildViewController" bundle:nil];
[self.spNavigationController pushViewController:child animated:YES animationType:UITransitionPushFromLeftSide];
```

3. Pop a view controller

```javascript
[self.spNavigationController popViewControllerAnimated:YES];
```

### <a name="transitions"></a> Transitions

Currently navigation controller supports 4 transitions that you cycle through by passing the below options

1. UITransitionPushFromLeftSide (default)
2. UITransitionPushFromRightSide
3. UITransitionPushFromTop
4. UITransitionPushFromBottom

Please see the sample project in the repository on how the transitions look and work

### <a name="minimum-requirement"></a> Minimum Requirements

iOS 5 and above only

### <a name="other"></a> Other
_(Coming soon)_
