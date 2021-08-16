const roomRouting = require('express').Router();
const {createRoom , getTeacherRooms} = require('../../controller/room/room');
const {user_auth_middle_ware} = require('../../middleware/auth');



roomRouting.route('/v1/room/create').post(createRoom);

roomRouting.route('/v1/room/getTeacherRooms').get(user_auth_middle_ware,getTeacherRooms);


module.exports = roomRouting;
