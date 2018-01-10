from ..kind.base import Base


class Kind(Base):
    """Denite kind for session.vim

    The source must have the following attribute

        action__session_name    A session name

    """
    def __init__(self, vim):
        super().__init__(vim)
        self.name = 'session'
        self.default_action = 'open'
        self.persist_actions = ['remove']
        self.redraw_actions = ['remove']

    def _get_session_name(self, context):
        session_name = context['targets'][0]['action__session_name']
        session_name = self.vim.call('fnameescape', session_name)
        return session_name

    def action_open(self, context):
        """Open a selected session"""
        session_name = self._get_session_name(context)
        self.vim.command('SessionOpen %s' % session_name)

    def action_open_force(self, context):
        """Open a selected session forcedly"""
        session_name = self._get_session_name(context)
        self.vim.command('SessionOpen! %s' % session_name)

    def action_remove(self, context):
        """Remove a selected session forcedly"""
        session_name = self._get_session_name(context)
        self.vim.command('SessionRemove %s' % session_name)
