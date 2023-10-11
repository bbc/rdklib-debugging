from aws_lambda_powertools import Logger
from rdklib import Evaluator, Evaluation, ConfigRule, ComplianceType

logger = Logger()

ON_CHANGE_RESOURCE_TYPES = [
    'AWS::IAM::Group',
    'AWS::IAM::Role',
    'AWS::IAM::User',
    'AWS::ElasticLoadBalancing::LoadBalancer',
    'AWS::RDS::DBInstance',
    'AWS::SNS::Topic',
    'AWS::SQS::Queue'
]

class ConfigRules(ConfigRule):

    def __init__(self):
        # Create NOT_APPLICABLE evaluations for resources that no longer exist
        self.delete_old_evaluations_on_scheduled_notification = True
        self.logger = Logger(child=True)

    def evaluate_periodic(self, event, client_factory, valid_rule_parameters):
        self.logger.info('Starting evaluation')

        evaluations = []

        evaluation = Evaluation(
            complianceType=ComplianceType.COMPLIANT,
            resourceId='my-test-role',
            resourceType='AWS::IAM::Role',
            annotation='rdklib debugging'
        )
        evaluation.import_fields_from_periodic_event(event)

        evaluations.append(evaluation)

        return evaluations

@logger.inject_lambda_context(log_event=True)
def handler(event, context):
    response = {}

    try:
        rules = ConfigRules()

        evaluator = Evaluator(rules, ON_CHANGE_RESOURCE_TYPES)

        response = evaluator.handle(event, context)
    except Exception as e:
        logger.exception(e)

    if 'internalErrorMessage' in response:
        logger.error(response)

    return response
