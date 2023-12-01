// Copyright 2023 The MathWorks, Inc.

#include "opentelemetry-matlab/metrics/MeterProxy.h"

#include "libmexclass/proxy/ProxyManager.h"

#include "MatlabDataArray.hpp"

#include <chrono>

namespace libmexclass::opentelemetry {

void MeterProxy::createSynchronous(libmexclass::proxy::method::Context& context, SynchronousInstrumentType type) {
    // Always assumes 3 inputs
   matlab::data::StringArray name_mda = context.inputs[0];
   std::string name = static_cast<std::string>(name_mda[0]);
   matlab::data::StringArray description_mda = context.inputs[1];
   std::string description= static_cast<std::string>(description_mda[0]);
   matlab::data::StringArray unit_mda = context.inputs[2];
   std::string unit = static_cast<std::string>(unit_mda[0]); 
	
   SynchronousInstrumentProxyFactory proxyfactory(CppMeter);
   auto proxy = proxyfactory.create(type, name, description, unit);
    
   // obtain a proxy ID
   libmexclass::proxy::ID proxyid = libmexclass::proxy::ProxyManager::manageProxy(proxy);

   // return the ID
   matlab::data::ArrayFactory factory;
   auto proxyid_mda = factory.createScalar<libmexclass::proxy::ID>(proxyid);
   context.outputs[0] = proxyid_mda;
}

void MeterProxy::createCounter(libmexclass::proxy::method::Context& context) {
   createSynchronous(context, SynchronousInstrumentType::Counter);
}


void MeterProxy::createUpDownCounter(libmexclass::proxy::method::Context& context) {
   createSynchronous(context, SynchronousInstrumentType::UpDownCounter);
}


void MeterProxy::createHistogram(libmexclass::proxy::method::Context& context) {
   createSynchronous(context, SynchronousInstrumentType::Histogram);
}


} // namespace libmexclass::opentelemetry
