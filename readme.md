# c938

<img width="1966" height="1250" alt="c938_menu" src="https://github.com/user-attachments/assets/bcbf5271-37bd-4a38-8ab5-b963bbfd74d9" />

## single_player

<img width="1966" height="1250" alt="c938_gameplay_enemies" src="https://github.com/user-attachments/assets/1b5cb13a-4750-48e5-b1cc-e651e9413ee1" />

| | |
|-|-|
| <img width="1966" height="1250" alt="c938_gameplay_projectiles" src="https://github.com/user-attachments/assets/9546c92c-52ea-415e-9d31-400a2384d2da" /> | <img width="1966" height="1250" alt="c938_projectiles_enemies" src="https://github.com/user-attachments/assets/440a737e-21d0-4f5c-b852-1a6d6c2c48c0" /> |

## multi_player

| | |
|-|-|
| <img width=1811 height=1200 alt=c938::multiplayer src=https://github.com/user-attachments/assets/57a8a7b0-c62f-4403-876d-e484e941254d /> | <img width=1920 height=1205 alt=c938::multiplayer::second src=https://github.com/user-attachments/assets/024f4976-f80a-439f-b983-fc9bbdee1307 /> |

<img width=1920 height=1206 alt=c938::multiplayer::third src=https://github.com/user-attachments/assets/2ea41731-9462-445d-968b-5a18830bebf7 />

### [host|client]::architecture

| host | client |
|-|-|
| <img width=239 height=57 alt=c938::network_host::notification src=https://github.com/user-attachments/assets/b0f87f21-bb2a-4678-bc13-aef578cb60f4 /> | <img width=227 height=19 alt=c938::network_client::notification src=https://github.com/user-attachments/assets/36561ecc-720d-4e01-8af2-65bb20640711 /> |
| <img width=295 height=256 alt=c938::network_host::terminal src=https://github.com/user-attachments/assets/d5ef49d9-a303-4c54-b91c-8554199bcc35 /> | <img width=221 height=95 alt=c938::network_client::terminal src=https://github.com/user-attachments/assets/9aa7ee71-9adf-4547-b466-c8cad12dc3b7 /> |

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

- [`alic3dev`](https://github.com/alic3dev)
- - [`cer0`](https://github.com/alic3dev/cer0)
- - [`clic3`](https://github.com/alic3dev/clic3)
- - [`interrupt_handler`](https://github.com/alic3dev/interrupt_handler)
- - [`math_c`](https://github.com/alic3dev/math_c)
- - [`metil`](https://github.com/alic3dev/metil)

### content

```zsh
make pull_content
```

#### redownload

```zsh
make pull_content_all
```

### build

```zsh
make
```

#### options

- `codesigning_id`:which_identity_to_use_for_codesigning
- `debug=1`:adds->{`debugging_symbols`}:disables->{`optimizations`};
- `device_identifier`:which_device_to_install_to_or_run_on
- `disable_metal_fast_options=1`:disables->{`metal`::`fast_modes `};
- `provisioning_profile_identifier`:which_provisioning_profile_identifier_to_use_for_signing_entitlements
- `pull_content_overwrite`:if_set->redownloads_all_content_even_if_the_files_already_exist.using(`pull_content`)
- `release=1`:uses_static_libraries_instead_of_dylibs
- `target_device`:sets_the_target_device_platform->{values::[`mac`|`iphone`]}
- `target_device_version`:sets_the_target_version.for->{`macos`|`metal`};
- `target_metal_standard`:sets_the_target_metal_standard::(will_use->{`metal4.0`}_if_not_set)
- `target_metal_version`:sets_the_target_metal_version::(will_use->{`target_device_version`}_if_not_set)

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

> © [copyleft|copyright] -> {alic3dev:2025|2026} -> ["all_rights_reserved" | "all_lefts_reserved"]
