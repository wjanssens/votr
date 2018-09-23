Ext.define('Votr.view.voter.Ballots', {
    extend: 'Ext.Container',
    alias: 'widget.voter.ballots',
    referenceHolder: true,
    viewModel: {
        stores: {
            ballots: 'voter.Ballots',
        }
    },
    bind: {
        store: '{ballots}'
    },
    getBlt: function() {
        var result = new Object();
        this.down("#ballots").getItems().forEach(c => {
            result[c.getData().id] = c.getData().blt;
        });
        return result;
    },
    setStore: function(store) {
        var c = this.down("#ballots");
        store.getData().items.forEach(record => {
            c.add(new Votr.view.voter.Ballot({ data: record.getData() }));
        });
    },
    layout: 'vbox',
    padding: 0,
    items: [
        {
            xtype: 'container',
            padding: 0,
            itemId: 'ballots',
        },
        {
            xtype: 'button',
            text: 'Vote',
            height: 32,
            margin: '16 0',
            ui: 'action',
            itemId: 'voteButton',
        }
    ]
});