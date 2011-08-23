# This will create an empty whitelist of attributes available for mass assignment for
# all models in your app. As such, your models will need to explicitly whitelist 
# accessible parameters by using an attr_accessible declaration. This technique is best
# applied at the start of a new project. However, for an existing project with a thorough
# set of functional tests, it should be straightforward and relatively quick to insert this
# initializer, run your tests, and expose each attribute (via attr_accessible) as dictated
# by your failing tests.

ActiveRecord::Base.send(:attr_accessible, nil)