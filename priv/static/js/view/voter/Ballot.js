Ext.define('Votr.view.voter.Ballot', {
    extend: 'Ext.panel.Panel',
    alias: 'widget.voter.ballot',
    border: false,
    shadow: true,
    padding: 8,
    margin: '16px 0',

    viewModel: {
        formulas: {
            methodName: function(get) {
                switch (get('method')) {
                    case 'scottish_stv': return 'Scottish STV';
                    case 'meek_stv': return 'Meek STV';
                    case 'plurality': return 'Plurality';
                    case 'approval': return 'Approval';
                    case 'condorcet': return 'Condorcet';
                    case 'borda': return 'Borda';
                };
            },
            order: function(get) {
                switch (get('shuffled')) {
                    case true: return 'Shuffled';
                    case false: return 'Official';
                };
            },
            publicText: function(get) {
                return get('public') ? 'Yes' : 'No'
            },
            mutableText: function(get) {
                return get('mutable') ? 'Yes' : 'No'
            }
        }
    },

    tools: [
        {
            iconCls: 'x-fa fa-info-circle',
            handler: function(panel) {
                var cards = panel.down('#cards');
                var item = cards.getActiveItem().getItemId() == 'info' ? 0 : 1;
                cards.setActiveItem(item);
            }
        }
    ],

    setData: function(data) {
        this.callParent(arguments);
        this.setTitle(data.title);
        this.getViewModel().setData(data);
        this.down('#description').setHtml(data.description);
        this.down('#messages').setHtml(this.getMessage());
        this.down('#cards').setHeight(data.candidates.length * 56);

        var panel = this.down('#candidates');
        data.candidates.forEach(candidate => {
            candidate.ranked = data.method.endsWith('_stv')
                || data.method == 'borda'
                || data.method == 'condorcet';
            candidate.rank = 0;
            candidate.max = candidate.ranked ? data.candidates.length : 1;
            var c = panel.add(new Votr.view.voter.Candidate({
                data: candidate,
                listeners: {
                    scope: this,
                    rank: {
                        fn: function(newValue) {
                            candidate.rank = newValue;
                            this.getData().blt = this.getBlt();
                            this.down('#messages').setHtml(this.getMessage());
                            console.log(this.getData().blt);
                        }
                    }
                }
            }));
        });
        console.log(panel.element)
    },
    getBlt: function() {
        // returns a string representation of the candidate ranking
        // https://www.opavote.com/help/overview#blt-file-format
        // no leading weight or trailing 0 included
        var data = this.getData();
        var maxRank = data.candidates
            .reduce((acc, v) => {
                return acc > v.rank ? acc : v.rank;
            }, 0);
        return data.candidates
            .filter(v => { return v.rank > 0; })
            .reduce((acc, v) => {
                acc[v.rank - 1] = acc[v.rank - 1].concat([v.index]);
                return acc;
            }, new Array(maxRank).fill([]))
            .map(a => { return a.length == 0 ? '-' : a.join('='); })
            .join(' ');
    },
    getMessage: function() {
        let data = this.getData();
        let blt = data.blt;
        let selected = data.candidates
            .filter(v => { return v.rank > 0; })
            .length;
        let message = '&nbsp;';
        if (data.method == 'plurality' && selected != 1 && data.electing == 1) {
            message = 'Select exactly one candidate';
        } else if (data.method == 'plurality' && selected == 0 && data.electing > 1) {
            message = 'Select one or more candidates';
        } else if (data.method == 'plurality' && selected > data.electing) {
            message = 'Select fewer candidates';
        } else if (data.method.endsWith('_stv') && selected == 0) {
            message = 'Rank at least one candidate';
        } else if (data.method.endsWith('_stv') && blt.indexOf('=') >= 0) {
            message = 'Rankings must be unique'; // no overvoting
        } else if (data.method == 'approval' && selected == 0) {
            message = 'Select one or more candidates';
        } else if (data.method == 'condorcet' && selected != data.candidates.length) {
            message = 'Rank all candidates';
        } else if (data.method == 'condorcet' && blt.indexOf('=') >= 0) {
            message = 'Rankings must be unique'; // no overvoting
        } else if (data.method == 'condorcet' && blt.indexOf('-') >= 0) {
            message = 'Rankings must be strictly increasing'; // no undervoting
        } else if (data.method == 'borda' && selected != data.candidates.length) {
            message = 'Rank all candidates';
        } else {
            return '&nbsp;';
        }
        return '<p style="color: var(--alert-color);">' + message + '</p>';
    },
    items: [
        {
            xtype: 'component',
            itemId: 'description',
            padding: 4,
            html: '<p>Description</p>'
        },
        {
            xtype: 'component',
            itemId: 'messages',
            padding: 4,
            html: '<p>Error / Warning Messages</p>'
        },
        {
            xtype: 'container',
            itemId: 'cards',
            padding: 0,
            layout: {
                type: 'card',
                animation: 'slide'
            },
            items: [
                {
                    xtype: 'container',
                    itemId: 'candidates',
                    padding: 0,
                    layout: 'vbox',
                    items: []
                },
                {
                    xtype: 'voter.ballotinfo',
                    itemId: 'info'
                }
            ]
        }
    ]
});