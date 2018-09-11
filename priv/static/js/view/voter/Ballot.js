Ext.define('Votr.view.voter.Ballot', {
    extend: 'Ext.panel.Panel',
    alias: 'widget.voter.ballot',
    layout: 'vbox',
    border: 1,
    padding: '8px',
    margin: '16px 0',
    title: 'Title',
    setData: function(data) {
        this.callParent(arguments);
        this.setTitle(data.title);
        this.down('#description').setHtml(data.description);
        this.down('#messages').setHtml(this.getMessage());

        var c = this.down('#candidates');
        data.candidates.forEach(candidate => {
            candidate.ranked = data.method == 'stv' || data.method == 'borda' || data.method == 'condorcet';
            candidate.rank = 0;
            candidate.max = candidate.ranked ? data.candidates.length : 1;
            c.add(new Votr.view.voter.Candidate({
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
        var data = this.getData();
        var blt = data.blt;
        var selected = data.candidates
            .filter(v => { return v.rank > 0; })
            .length;
        if (data.method == 'plurality' && selected < data.electing) {
            return '<p style="color: var(--alert-color);">Select more candidates</p>';
        } else if (data.method == 'plurality' && selected > data.electing) {
            return '<p style="color: var(--alert-color);">Select fewer candidates</p>';
        } else if (data.method == 'stv' && selected == 0) {
            return '<p style="color: var(--alert-color);">Rank at least one candidate</p>';
        } else if (data.method == 'stv' && blt.indexOf('=') >= 0) {
            return '<p style="color: var(--alert-color);">Rankings must be unique</p>'; // no overvoting
        } else if (data.method == 'approval' && selected == 0) {
            return '<p style="color: var(--alert-color);">Select at least one candidate</p>';
        } else if (data.method == 'condorcet' && selected != data.candidates.length) {
            return '<p style="color: var(--alert-color);">Rank all candidates</p>';
        } else if (data.method == 'condorcet' && blt.indexOf('=') >= 0) {
            return '<p style="color: var(--alert-color);">Rankings must be unique</p>'; // no overvoting
        } else if (data.method == 'condorcet' && blt.indexOf('-') >= 0) {
            return '<p style="color: var(--alert-color);">Rankings must be strictly increasing</p>'; // no undervoting
        } else if (data.method == 'borda' && selected != data.candidates.length) {
            return '<p style="color: var(--alert-color);">Rank all candidates</p>';
        } else {
            return '&nbsp;';
        }
    },
    items: [
        {
            xtype: 'panel',
            itemId: 'header',
            padding: 0,
            layout: 'vbox',
            items: [
                {
                    xtype: 'component',
                    itemId: 'description',
                    padding: '8px',
                    html: 'Description'
                },
                {
                    xtype: 'component',
                    itemId: 'messages',
                    padding: '8px',
                    html: 'Error / Warning Messages'
                }
            ]
        },
        {
            xtype: 'panel',
            itemId: 'candidates',
            padding: 0,
            layout: 'vbox',
            items: [

            ]
        }
    ]
});