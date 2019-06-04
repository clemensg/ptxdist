project('@name@', 'c',
  version : '@version@',
  license : '0BSD',
  default_options : ['warning_level=3'])

conf_data = configuration_data()
conf_data.set('version', meson.project_version())
conf_data.set('license', meson.project_license()[0])
configure_file(input : 'config.h.in',
               output : 'config.h',
               configuration : conf_data)

executable('@name@',
           '@name@.c',
           install : true)
