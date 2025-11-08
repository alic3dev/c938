# c938

<img width="1966" height="1250" alt="menu" src="https://github.com/user-attachments/assets/6b421c0b-a92c-454e-bb34-d4ae54464169" />
<img width="1966" height="1250" alt="gameplay" src="https://github.com/user-attachments/assets/29cf2462-5946-4613-8e99-76fc64576f98" />

## requirements

- os->{`macos`}
- - version.minimum->{`15.0`};
- - - defaults:to->{`26.0`};
- - - override_with:`target_macos_version`
- - with->{`metal`}.support();

### frameworks

- `metal`
- `metalkit`
- `gamecontroller`
- `coreaudio`
- `coregraphics`
- `coretext`

## configuration

- path->{`~/.config/c938`};
- parameter:name->{value}
- - `audio:volume`: `float`
- - `rendering_properties:brightness`: `float`
- - `rendering_properties:brightness_text`: `float`
- - `rendering_properties:fps_display`: `int`

### example

```
audio:volume->{0.27f};
rendering_properties:brightness->{0.8f};
rendering_properties:fps_display->{1};
```

## development

### prerequisites

- [`alic3`](https://github.com/alic3dev):libraries
- - [`cer0`](https://github.com/alic3dev/cer0)
- - [`clic3`](https://github.com/alic3dev/clic3)
- - [`interrupt_handler`](https://github.com/alic3dev/interrupt_handler)
- - [`math_c`](https://github.com/alic3dev/math_c)
- - [`metil`](https://github.com/alic3dev/metil)

### assets

```zsh
make pull_assets
```

#### redownload

```zsh
make pull_assets_all
```

### build

```zsh
make
```

#### options

- `release=1`:uses_static_libraries_instead_of_dylibs
- `debug=1`:adds->{`debugging_symbols`}:disables->{`optimizations`};
- `disable_metal_fast_options=1`:disables->{`metal`::`fast_modes `};
- `target_macos_version`:sets_the_target_version.for->{`macos`|`metal`};

```zsh
parameter=value make
: or
parameter_1=value_1 parameter_2=value_2 make
```

### clean

```zsh
make clean
```

## copyright | copyleft

> © [copyleft|copyright] -> {alic3dev:2025} -> ["all_rights_reserved" | "all_lefts_reserved"]
