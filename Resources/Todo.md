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
- [x] Finish current pocket -> pocketViewData refactor
-> - Migrate to pocketViewData ✅
   - Create a new array to store the global position of the pockets -> This became fishing in the grid collection
   - Remove the in view data
   - Connect the functions to the viewdata storage
- [x] Give subscriptions names so you can follow who's doing what
- [ ] Implement the leveling up logic in Game VC
