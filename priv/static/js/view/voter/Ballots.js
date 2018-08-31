Ext.define('Votr.view.voter.Ballots', {
    extend: 'Ext.panel.Panel',
    alias: 'widget.voter.ballots',
    layout: 'hbox',
    scrollable: true,
    items: [
        {
            xtype: 'panel',
            flex: 1
        },
        {
            xtype: 'panel',
            items: [
                {
                    xtype: 'panel',
                    padding: '16px auto',
                    html: 'Instructions'
                },
                {
                    xtype: 'voter.ballot'
                }, {
                    xtype: 'voter.ballot'
                }, {
                    xtype: 'voter.ballot'
                }, {
                    xtype: 'voter.ballot'
                }
            ]
        },
        {
            xtype: 'panel',
            flex: 1
        }
    ]
});