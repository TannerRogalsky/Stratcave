Base
  > Level
    - Screen < Base
      - Layer < Base
  > Character
    > Player
    > Non-Player
  > Item
  > Game
  > Camera

- = uses
> = subclasses


#### Base
Base class for all other classes. Probably just provides update and render methods to override.

#### Game
Has levels and states and whatnot. Could also be thought of as the World class.

#### Camera
Does what it sounds like it does. Mostly just a helper for now. Nothing complicated as all the rendering is handled by the objects themselves.

#### Level
An object encompassing all the concepts of a traditional level: has multiples screens that the player passes through, acts as a vessel for the visualization of all the game objects. Probably convenient to define it via JSON.

#### Screen
Belongs to a level. Contains many layers. Should a pretty simple class but if we want to do custom scripting on a per screen basis, this is where we want to do it.

Screen should ultimately implement a skiplist for drawing to speed up z-indexing.

The layer at z-index 0 should be reserved for the player and physics objects. Unless separating the physics and the visual will cause problems. Might have to think of another solution to this.

#### Layer
Each screen will have at least one of these. They should define the background, the terrain and the foreground. They should support transparency and parallaxing because that shit looks cool.

The actual layer renderings should be comprise not of a single image but of references (quads) to image sections. Ideally, we could reference more than one image per layer. We may want to define a class just for that as it looks like it might add unnecessary complexity to the Layer class.

In the level data, the object would need to define a file and references to coordinates in that file as well as the coordinates that this object belongs on the layer.

#### Character
Superclass for all character type objects.

#### Player Character
Character directly controllable by the player.

#### Non-Player Character
May not even be neccesary. All of the functionality may exist within the Character superclass.

#### Item
Will exist within a layer but ownership will be transfered to the Player. Will need to be able to modify attributes on the Player as well as probably some custom scripting.
