enum UserRole { parent, child }

UserRole roleFromString(String v) =>
    v == 'child' ? UserRole.child : UserRole.parent;

String roleToString(UserRole r) =>
    r == UserRole.child ? 'child' : 'parent';
