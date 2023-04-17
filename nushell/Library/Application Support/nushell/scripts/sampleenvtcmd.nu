# Update replacement for env command
# Author: @fdncred
# Source: https://discord.com/channels/601130461678272522/615253963645911060/1095335966228627476

# get the environment details
def "env details" [] {
  let e = ($env | reject config | transpose key value)
  $e | each { |r|
    let is_envc = ($r.key == ENV_CONVERSIONS)
    let is_closure = ($r.value | describe | str contains 'closure')
    let is_list = ($r.value | describe | str contains 'list')
    if $is_envc {
      echo [[key value]; 
        [($r.key) ($r.value | transpose key value | each { |ec| 
          let to_string = ($ec.value | get to_string | view source $in | nu-highlight)
          let from_string = ($ec.value | get from_string | view source $in | nu-highlight)
          echo ({'ENV_CONVERSIONS': {($ec.key): { 'to_string': ($to_string) 'from_string': ($from_string)}}})
        })]
      ]
    } else if $is_closure {
      let closure_value = (view source ($env | get $r.key) | nu-highlight)
      echo [[key value]; [($r.key) ($closure_value)]]
    } else if $is_list {
      let list_value = ($env | get $r.key | split row (char esep))
      echo [[key value]; [($r.key) ($list_value)]]
    } else {
      echo [[key value]; [($r.key) ($r.value)]]
    }
  }
}