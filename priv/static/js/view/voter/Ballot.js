Ext.define('Votr.view.voter.Ballot', {
    extend: 'Ext.panel.Panel',
    alias: 'widget.voter.ballot',
    layout: 'vbox',
    width: 512,
    border: 1,
    padding: 0,
    margin: '16px auto',
    items: [{
        xtype: 'panel',
        title: 'Title',
        items: [
            {
                xtype: 'panel',
                padding: '16px auto',
                html: 'Instructions'
            },
            {
                xtype: 'voter.candidate',
                data: { name: 'Name 1', description: 'Ranked 1', rank: 3, max: 99, ranked: true }
            }, {
                xtype: 'voter.candidate',
                data: { name: 'Name 2', description: 'Ranked 2', rank: 0, max: 99, ranked: true }
            }, {
                xtype: 'voter.candidate',
                data: { name: 'Name 3', description: 'Unranked 1', rank: 1, max: 1, ranked: false }
            }, {
                xtype: 'voter.candidate',
                data: { name: 'Name 4', description: 'Unranked 2', rank: 0, max: 1, ranked: false }
            }
        ]
    }]
});