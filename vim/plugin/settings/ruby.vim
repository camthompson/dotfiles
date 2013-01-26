let g:rubycomplete_buffer_loading = 1
let g:rubycomplete_classes_in_global = 1
let g:rubycomplete_rails = 1
au BufEnter Gemfile,Rakefile,Thorfile,config.ru,Guardfile,Capfile,Vagrantfile setfiletype ruby
au BufEnter *pryrc,*irbrc,*railsrc setfiletype ruby
au FileType ruby,haml,eruby,yaml,html,javascript,sass,cucumber,coffee set ai sw=2 sts=2 et
