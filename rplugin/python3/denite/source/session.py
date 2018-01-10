import os
from os.path import normpath, basename, splitext, expanduser, expandvars
from ..source.base import Base


class Source(Base):
    """Denite source for session.vim"""

    def __init__(self, vim):
        super().__init__(vim)
        self.name = 'session'
        self.kind = 'session'

    def _create_candidate(self, filename, this_session):
        is_active = normpath(filename) == this_session
        session_name = splitext(basename(filename))[0]
        return {
            'word': session_name,
            'abbr': '%s %s' % ('*' if is_active else ' ', session_name),
            'action__session_name': session_name,
            'action__session_active': is_active,
        }

    def highlight(self):
        self.vim.command(
            'highlight default link deniteSource_sessionActive Title'
        )

    def define_syntax(self):
        self.vim.command(
            'syntax match deniteSource_sessionActive '
            r'/\* .*/ display'
        )

    def gather_candidates(self, context):
        session_dir = expanduser(expandvars(self.vim.vars['session_dir']))
        this_session = normpath(self.vim.vvars['this_session'])
        return [
            self._create_candidate(f, this_session)
            for f in iterate_session_files(session_dir)
        ]


if hasattr(os, 'scandir'):
    def iterate_session_files(session_dir):
        with os.scandir(session_dir) as it:
            for entry in it:
                if entry.name.endswith('.vim') and entry.is_file():
                    yield entry.path
else:
    def iterate_session_files(session_dir):
        for path in os.listdir(session_dir):
            if path.endswith('.vim') and os.path.isfile(path):
                yield path
