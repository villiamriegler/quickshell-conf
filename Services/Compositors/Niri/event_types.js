/*
 * Niri ipc type definitions
 */

/**
 * Definition of Workspace type 
 *
 * @typedef {Object} Workspace
 * @property {number} id
 * @property {number} idx
 * @property {string | null} name
 * @property {string | null} output
 * @property {boolean} is_urgent
 * @property {boolean} is_active
 * @property {boolean} is_focused
 * @property {number | null} active_window_id
 */

/**
 * Definition of WindowLayout type 
 *
 * @typedef {Object} WindowLayout
 * @property {number[2] | null} pos_in_scrolling_layout
 * @property {number[2]} tile_size
 * @property {number[2]} window_size
 * @property {number[2] | null} tile_pos_in_workspace_view
 * @property {number[2]} window_offset_in_tile
 */

/**
 * Definition of Window type 
 *
 * @typedef {Object} Window
 * @property {number} id
 * @property {string | null} title
 * @property {string | null} app_id
 * @property {number | null} pid
 * @property {number | null} workspace_id
 * @property {boolean} is_focused
 * @property {boolean} is_floating
 * @property {boolean} is_urgent
 * @property {WindowLayout} layout
 * @property {Date | null} focus_timestamp
 */

/**
 * Definition of KeyboardLayouts type 
 *
 * @typedef {Object} KeyboardLayouts 
 * @property {string[]} names
 * @property {number} current_idx
 */

/*
 * Niri ipc event definitions recived over the socket event stream
 */

/**
 * WorkspacesChanged event
 *
 * @typedef {Object} WorkspacesChanged
 * @property {Workspace[]} workspaces
 */

/**
 * WorkspaceUrgencyChanged event
 *
 * @typedef {Object} WorkspaceUrgencyChanged
 * @property {number} id
 * @property {boolean} urgent
 */

/**
 * WorkspaceActivated event
 *
 * @typedef {Object} WorkspaceActivated
 * @property {number} id
 * @property {boolean} focused
 */

/**
 * WorkspaceActiveWindowChanged event
 *
 * @typedef {Object} WorkspaceActivated
 * @property {number} workspace_id
 * @property {number | null} active_window_id
 */

/**
 * WindowsChanged event
 *
 * @typedef {Object} WindowsChanged
 * @property {Window[]} windows
 */

/**
 * WindowOpenedOrChanged event
 *
 * @typedef {Object} WindowOpenedOrChanged
 * @property {Window} window
 */

/**
 * WindowClosed event
 *
 * @typedef {Object} WindowOpenedOrChanged
 * @property {number} id
 */

/**
 * WindowFocusChanged event
 *
 * @typedef {Object} WindowFocusChanged 
 * @property {number | null} id
 */

/**
 * WindowFocusTimestampChanged event
 *
 * @typedef {Object} WindowFocusTimestampChanged 
 * @property {number} id
 * @property {Date | null} focus_timestamp
 */

/**
 * WindowUrgencyChanged event
 *
 * @typedef {Object} WindowUrgencyChanged 
 * @property {number} id
 * @property {boolean} urgent
 */

/**
 * WindowLayoutsChanged event
 *
 * @typedef {Object} WindowLayoutsChanged 
 * @property {[number, WindowLayout][]} changes
 */

/**
 * KeyboardLayoutsChanged event 
 *
 * @typedef {Object} KeyboardLayoutsChanged  
 * @property {KeyboardLayouts} changes
 */

/**
 * KeyboardLayoutSwitched event 
 *
 * @typedef {Object} KeyboardLayoutSwitched   
 * @property {number} idx
 */

/**
 * OverviewOpenedOrClosed event 
 *
 * @typedef {Object} OverviewOpenedOrClosed    
 * @property {boolean} is_open
 */

/**
 * ConfigLoaded event 
 *
 * @typedef {Object} ConfigLoaded     
 * @property {boolean} failed
 */

/**
 * ScreenshotCaptured event 
 *
 * @typedef {Object} ScreenshotCaptured     
 * @property {string | null} path
 */

/**
 * ScreenshotCaptured event 
 *
 * @typedef {Object} ScreenshotCaptured     
 * @property {string | null} path
 */
