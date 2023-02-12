# Philosophy

> This is an experiment in fluid gestures and UX art.

_Sketch_
The main stage is a _board with pockets_.
The user can _flick the ball_ to land in the pockets.
This creates a _visual and haptic trail_.
Sound can be a element.

_Purpose_
None. A fun fidget app.
A great way to learn.
 
 
## The Well 
The basis for this project is this [**phenomenal** post](https://medium.com/@nathangitter/building-fluid-interfaces-ios-swift-9732bb934bf5)
[Apple Haptics](https://developer.apple.com/documentation/corehaptics/delivering_rich_app_experiences_with_haptics)

## Learnings
State machines are cool, but you have to be discplined. 
- Make sure not to put the side effects in the state machine
- Handle side-effects in the subscribe functions of your classes
- Hide the state so you encourage yourself not to use it in comparison

It's a cool way to think though...
Each class that subscribes has a responsibility (showing something, updating UI, playing a sound), you go to the class 
and think "what should it do in this state?" and add the side effects in the subscribtion.
