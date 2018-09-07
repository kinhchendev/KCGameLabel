# KCGameLabel
Swift framework for label animations


# Install
- Via Cocoapod:
	pod 'KCGameLabel'

- Add to Project:
	Add 'KCGameLabel.framework' to Embedded Binaries in Project->General

# Usage
- Import: 
```
	import KCGameLabel
```

- Initialization:
```
	let lbGame = GameLabel.initGameLabel(WithStyle: .bounce)

	lbGame.animatedDuration = 0.4
    lbGame.animatedInterval = 0.45
    lbGame.backgroundColor = .white
    lbGame.frame = CGRect(x: 20, y: 200, width: self.view.frame.size.width - 2*20, height: 100)
    lbGame.setLabelFont(font: UIFont.boldSystemFont(ofSize: 60))
    lbGame.setLabelColor(color: .red)
    self.view.addSubview(lbGame)
```

- Change value and it will animate automatically
```
	lbGame.text = "\(count)"
```