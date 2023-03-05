#  Todo & Strategy

## Context
Apple advises SpriteKit apps to be built with one ViewController that manages one scene.

## The challenge
They way I have built the app now involves multiple VC's, a navigationcontroller and many scenes.

## Strategy
1. Detach all the subscribes
2. Clean them up and reduce them
3. Build up the subscriptions 1 by one
4. Document the states in a storyform

### Todo's
- [ ] Finish current pocket -> pocketViewData refactor
-> - Migrate to pocketViewData
   - Create a new array to store the global position of the pockets
   - Remove the in view data
   - Connect the functions to the viewdata storage
- [ ] Remove subscriptions
- [ ] Write down the flow of the game
- [ ] Hightlight the states
- [ ] Make pseudo code out of the story 
