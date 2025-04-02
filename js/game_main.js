const tileSize = 8
const width = 80
const height = 80;


class Map extends Phaser.Scene
{
      graphics;

      create () {
            // set crisp rendering
            // PIXI.scaleModes.DEFAULT = PIXI.scaleModes.NEAREST;
            // this.game.stage.smoothed = false;
            // Phaser.Canvas.setSmoothingEnabled(this.game.context, false);

            let rect = this.add.rectangle(100, 100, tileSize, tileSize, 0x000000, 1);
            rect.setStrokeStyle(1, 0xfff000);
      }
}


const config = {
      type: Phaser.AUTO,
      width: 400,
      height: 300,
      scene: Map,
      scale: {
            // Fit to window
            mode: Phaser.Scale.FIT,
            // Center vertically and horizontally
            autoCenter: Phaser.Scale.CENTER_BOTH
      },
      pixelArt: true,
  };

  const game = new Phaser.Game(config);