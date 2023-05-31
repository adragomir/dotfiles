DEBUG = 0
USE_CMDS = 1

import lldb
if DEBUG:
  import debugpy

def String( valobj: lldb.SBValue, internal_dict, options ):
  data: lldb.SBValue = valobj.GetChildMemberWithName('data')
  len = valobj.GetChildMemberWithName('count').GetValueAsSigned(0)
  if len == 0:
    return ""
  if len < 0:
    return "invalid length (" + str(len) + ")"
  if len > 0xFFFFFFFF:
    return "length is too big for LLDB's puny python bridge (" + str(len) + ")"
  # HACK: Assume it's utf-8.... I wonder if options contains an encoding option?
  return ( '"'
           + bytes( data.GetPointeeData(0, len).uint8s ).decode( 'utf-8' )
           + '"' )
   

# Annoyingly summary strings suppress the printing of the child members by
# default. This is crappy, and means we have to write that code ourselves, but
# it's not even that trivial as just printing the "GetValue()" of each child
# prints "None", helpfully.
def Array( valobj: lldb.SBValue, internal_dict, options ):
  raw: lldb.SBValue = valobj.GetNonSyntheticValue()
  return ( "Array(count="
           + str( raw.GetChildMemberWithName( 'count' ).GetValueAsSigned() )
           + ")" )

def ResizableArray( valobj: lldb.SBValue, internal_dict, options ):
  raw: lldb.SBValue = valobj.GetNonSyntheticValue()
  data = raw.GetChildMemberWithName( 'data' ).GetValueAsSigned()
  if data == 0:
    return ( "Array(uninitialised)" )

  return ( "Array(count="
           + str( raw.GetChildMemberWithName( 'count' ).GetValueAsSigned() )
           + ",allocated="
           + str( raw.GetChildMemberWithName( 'allocated' ).GetValueAsSigned() )
           + ")" )

class ArrayChildrenProvider:
  def __init__( self, valobj: lldb.SBValue, internal_dict) :
    self.val = valobj

  def update(self):
    self.count = self.val.GetChildMemberWithName( 'count' ).GetValueAsSigned()
    self.data: lldb.SBValue = self.val.GetChildMemberWithName('data')
    self.data_type: lldb.SBType = self.data.GetType().GetPointeeType()
    self.data_size = self.data_type.GetByteSize()

    return False

  def has_children(self):
    return True

  def num_children(self):
    return self.count

  def get_child_at_index(self, index):
    return self.data.CreateChildAtOffset( str(index),
                                          self.data_size * index,
                                          self.data_type )

  def get_child_index(self, name):
    return int( name )


def __lldb_init_module( debugger: lldb.SBDebugger, dict ):
  if DEBUG:
    debugpy.listen( 5432 )
    debugpy.wait_for_client()

  if USE_CMDS:
    C = debugger.HandleCommand
    C( "type summary add -w Jai string -F jaitype.String" )
    C( r"type summary add -e -w Jai -x '\[\] .*' -F jaitype.Array" )
    C( r"type summary add -e -w Jai -x '\[\.\.\] .*' -F jaitype.ResizableArray" )
    C( r"type synthetic add -w Jai -x '\[\] .*' -l jaitype.ArrayChildrenProvider" )
    C( r"type synthetic add -w Jai -x '\[\.\.\] .*' -l jaitype.ArrayChildrenProvider" )
    C( 'type category enable Jai' )
  else:
    # I can't work out how to specify the equivalent of "-e" here (or stricly
    # the opposite, as the default appears to be to show all chilren, and
    # _don't_ want to for string)
    # There seem to be conflicting and overlapping flags in the lldb code:
    #  eTypeOptionShowOneLiner, eTypeOptionHideChildren, etc.
    # These all set flags on the various formatters (it's get/set methods all
    # the way down), but i can't see them exposed in python. There's an options
    # field on SBTypeSummary.CreateWithFunctionName, but i couldn't find a way
    # to make it work)
    #
    # Anyway it works with the command line, which sets the defaults like this:
    #
    # m_flags.Clear().SetCascades().SetDontShowChildren().SetDontShowValue(false);
    # m_flags.SetShowMembersOneLiner(false)
    #     .SetSkipPointers(false)
    #     .SetSkipReferences(false)
    #     .SetHideItemNames(false);

    cat: lldb.SBTypeCategory = debugger.CreateCategory("Jai")

    string = lldb.SBTypeNameSpecifier( "string" )
    cat.AddTypeSummary( string,
                        lldb.SBTypeSummary.CreateWithFunctionName(
                          'jaitype.String', ) )

    array = lldb.SBTypeNameSpecifier( r'\[\] .*', True )
    cat.AddTypeSummary(
      array,
      lldb.SBTypeSummary.CreateWithFunctionName( 'jaitype.Array' ) )
    cat.AddTypeSynthetic(
      array,
      lldb.SBTypeSynthetic.CreateWithClassName(
        'jaitype.ArrayChildrenProvider' ) )

    rarray = lldb.SBTypeNameSpecifier( r'\[\.\.\] .*', True )
    cat.AddTypeSummary(
      rarray,
      lldb.SBTypeSummary.CreateWithFunctionName( 'jaitype.ResizableArray' ) )
    cat.AddTypeSynthetic(
      rarray,
      lldb.SBTypeSynthetic.CreateWithClassName(
        'jaitype.ArrayChildrenProvider' ) )

    cat.SetEnabled(True)
