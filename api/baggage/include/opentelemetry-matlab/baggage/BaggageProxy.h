// Copyright 2023 The MathWorks, Inc.

#pragma once

#include "libmexclass/proxy/Proxy.h"
#include "libmexclass/proxy/method/Context.h"

namespace baggage_api = opentelemetry::baggage;
namespace context_api = opentelemetry::context;
namespace nostd = opentelemetry::nostd;

namespace libmexclass::opentelemetry {
class BaggageProxy : public libmexclass::proxy::Proxy {
  public:
    BaggageProxy(const libmexclass::proxy::FunctionArguments& constructor_arguments); 

    void getAllEntries(libmexclass::proxy::method::Context& context);
    void setEntries(libmexclass::proxy::method::Context& context);
    void deleteEntries(libmexclass::proxy::method::Context& context);
    void insertBaggage(libmexclass::proxy::method::Context& context);

  private:

    nostd::shared_ptr<baggage_api::Baggage> CppBaggage;
};
} // namespace libmexclass::opentelemetry
