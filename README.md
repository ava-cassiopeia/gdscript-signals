# GDScript Signals

A Godot 4.x plugin which provides a `Signals` class which exposes static
functions for interacting with lists of Signals, like `Promise.all()` in
JavaScript.

## Usage

After importing and enabling the plugin, use one of the static methods attached
to `Signals` detailed below.

### all(signals_list)->Array

Given a list of
[Signal](https://docs.godotengine.org/en/stable/classes/class_signal.html)s,
waits until all of the signals complete, then returns an array of the results
from the signals, matching the order the signals were passed in.

**Example:**

```gdscript
var results := await Signals.all([
	weapon.target_was_hit,
	weapon.animation_complete
])
```

### any(signals_list)

Given a list of
[Signal](https://docs.godotengine.org/en/stable/classes/class_signal.html)s,
waits until at least one of those signals completes, returning the result of
that completed signal.

**Example:**

```gdscript
var result = await Signals.any([
	target.damage_taken,
	bullet.expired
])
```

## Contributing

Feel free to send pull requests or issues. This repository is a complete Godot
4.x project, so it can be imported locally for development.

**Note:** This repo comes with [Gut](https://github.com/bitwes/Gut/) unit tests,
please make sure to add new test coverage and check existing tests when adding
or changing code.
