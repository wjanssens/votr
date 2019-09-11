Ext.define('Votr.view.index.Login', {
    extend: 'Ext.TabPanel',
    alias: 'widget.index.login',
    height: 320,
    shadow: true,
    flex: 2,
    requires: [
        "Votr.view.index.LoginController"
    ],
    controller: 'index.login',
    itemId: 'login',
    items: [
        {
            title: 'Vote'.translate(),
            xtype: 'formpanel',
            itemId: 'voterId',
            padding: 16,
            items: [
                {
                    xtype: 'textfield',
                    name: 'access_code',
                    label: 'Access Code'.translate(),
                    autoCapitalize: true,
                    listeners: {
                        initialize: 'installCodeFormatter'
                    }
                }, {
                    xtype: 'textfield',
                    name: 'identification_number',
                    label: 'Identification Number'.translate()
                }, {
                    itemId: 'message',
                    html: '',
                }, {
                    flex: 1,
                }, {
                    xtype: 'toolbar',
                    docked: 'bottom',
                    items: [
                        '->',
                        {
                            xtype: 'button',
                            text: 'Next'.translate(),
                            handler: 'onVoterCredentials'
                        }
                    ]
                }
            ]
        },
        {
            title: 'Sign In'.translate(),
            layout: 'card',
            itemId: 'signInCards',
            items: [
                {
                    xtype: 'formpanel',
                    padding: 16,
                    itemId: 'adminId',
                    items: [
                        {
                            xtype: 'textfield',
                            name: 'email',
                            label: 'Email Address'.translate()
                        }, {
                            xtype: 'passwordfield',
                            name: 'password',
                            label: 'Password'.translate()
                        }, {
                            flex: 1
                        }, {
                            itemId: 'message',
                            html: ''
                        }, {
                            xtype: 'toolbar',
                            docked: 'bottom',
                            items: [
                                {
                                    xtype: 'button',
                                    text: 'Forgot Password'.translate(),
                                    handler: 'onAdminForgotPassword'
                                }, '->', {
                                    xtype: 'button',
                                    text: 'Next'.translate(),
                                    handler: 'onAdminCredentials'
                                }
                            ]
                        }
                    ]
                }, {
                    xtype: 'formpanel',
                    padding: 16,
                    itemId: 'adminMfa',
                    items: [
                        {
                            xtype: 'textfield',
                            name: 'code',
                            label: 'Code'
                        },
                        {
                            flex: 1
                        },
                        {
                            itemId: 'message',
                            html: 'Enter the code from your two-factor authentication app, or alternatively, use one of your backup codes.'.translate()
                        },
                        {
                            xtype: 'toolbar',
                            docked: 'bottom',
                            items: [
                                '->',
                                {
                                    xtype: 'button',
                                    text: 'Verify',
                                    handler: 'onAdminMfa'
                                }
                            ]
                        }
                    ]
                }
            ]
        },
        {
            title: 'Sign Up'.translate(),
            layout: 'card',
            itemId: 'signUpCards',
            padding: 16,
            listeners: {
                activate: 'validateRegistration'
            },
            items: [
                {
                    xtype: 'formpanel',
                    padding: 16,
                    itemId: 'register',
                    items: [
                        {
                            xtype: 'emailfield',
                            name: 'email',
                            itemId: 'email',
                            label: 'Email Address'.translate(),
                            value: '',
                            listeners: {
                                change: 'validateRegistration'
                            }
                        }, {
                            xtype: 'passwordfield',
                            name: 'password',
                            itemId: 'password',
                            label: 'Password'.translate(),
                            value: '',
                            listeners: {
                                change: 'validateRegistration'
                            }
                        }, {
                            xtype: 'passwordfield',
                            name: 'retype_password',
                            itemId: 'retype_password',
                            label: 'Retype Password'.translate(),
                            value: '',
                            listeners: {
                                change: 'validateRegistration'
                            }
                        }, {
                            flex: 1
                        }, {
                            itemId: 'message',
                            html: ''
                        }, {
                            xtype: 'toolbar',
                            docked: 'bottom',
                            items: [
                                '->',
                                {
                                    xtype: 'button',
                                    itemId: 'next',
                                    text: 'Next'.translate(),
                                    disabled: true,
                                    handler: 'onAdminRegistration'
                                }
                            ]
                        }
                    ]
                }, {
                    xtype: 'formpanel',
                    padding: 16,
                    itemId: 'confirm',
                    items: [
                        {
                            xtype: 'textfield',
                            itemId: 'code',
                            name: 'code',
                            label: 'Code'.translate(),
                            autoCapitalize: true,
                            autoCorrect: false,
                            autoComplete: false,
                            listeners: {
                                keyup: 'onEmailConfirmationKeyUp'
                            }
                        }, {
                            flex: 1
                        }, {
                            itemId: 'message',
                            html: 'Confirm receipt of the email we sent you.'.translate()
                        }, {
                            xtype: 'toolbar',
                            docked: 'bottom',
                            items: [
                                '->', {
                                    xtype: 'button',
                                    itemId: 'next',
                                    text: 'Next'.translate(),
                                    handler: 'onEmailConfirmation'
                                }
                            ]
                        }
                    ]
                }
            ]
        }
    ]
});
