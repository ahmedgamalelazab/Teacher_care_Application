const {getGovernorates , getCities , governorateRelatedCities , getSpecificCity , getGovernorateById , getCityById} = require('../../controller/address/address');
const addressRouter = require('express').Router();


addressRouter.route('/v1/governorate').get(getGovernorates);

addressRouter.route('/v1/cities').get(getCities);

addressRouter.route('/v1/governorateRelatedCity').get(governorateRelatedCities);

addressRouter.route('/v1/cities/one').get(getSpecificCity);

addressRouter.route('/v1/governorate/:id').get(getGovernorateById);

addressRouter.route('/v1/cities/:id').get(getCityById);

module.exports = addressRouter;